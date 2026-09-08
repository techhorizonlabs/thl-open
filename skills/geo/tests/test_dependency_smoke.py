"""Offline behavior checks for the deployment lock; real libraries, mocked HTTP."""
import importlib.util
from pathlib import Path
import socket
import tempfile
import unittest
from unittest.mock import Mock, patch

SCRIPTS = Path(__file__).resolve().parents[1] / 'scripts'

def load(name):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / (name + '.py'))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

fetch = load('fetch_page')
llms = load('llmstxt_generator')
pdf = load('generate_pdf_report')


def response(text, status=200):
    return Mock(text=text, status_code=status, headers={'content-type': 'text/html'}, history=[])


class DependencySmoke(unittest.TestCase):
    def setUp(self):
        # Any accidentally unmocked HTTP connection fails this offline suite.
        self.network = patch.object(socket.socket, 'connect', side_effect=AssertionError('Unexpected real network'))
        self.network.start()
        self.addCleanup(self.network.stop)

    def test_html_metadata_links_and_structured_data(self):
        html = '''<html><head><title>Example</title><meta name="description" content="A test page">
        <script type="application/ld+json">{"@type":"Organization","name":"Example"}</script></head>
        <body><h1>Test heading</h1><p>Content for a synthetic audit.</p>
        <a href="/about">About</a><a href="https://other.example/">External</a></body></html>'''
        with patch.object(fetch.requests, 'get', return_value=response(html)):
            result = fetch.fetch_page('https://example.test/')
        self.assertEqual(result['title'], 'Example')
        self.assertEqual(result['description'], 'A test page')
        self.assertEqual(result['h1_tags'], ['Test heading'])
        self.assertEqual(result['internal_links'][0]['url'], 'https://example.test/about')
        self.assertEqual(result['external_links'][0]['url'], 'https://other.example/')
        self.assertEqual(result['structured_data'][0]['name'], 'Example')

    def test_fetch_timeout_is_an_error_not_a_valid_page(self):
        with patch.object(fetch.requests, 'get', side_effect=fetch.requests.exceptions.Timeout()):
            result = fetch.fetch_page('https://example.test/')
        self.assertIsNone(result['status_code'])
        self.assertTrue(result['errors'])

    def test_llms_generation_uses_internal_pages_and_parses_descriptions(self):
        home = '<title>Example | Home</title><meta name="description" content="Home description"><a href="/about">About us</a><a href="https://other.example/">Elsewhere</a>'
        about = '<meta name="description" content="About this business">'
        with patch.object(llms.requests, 'get', side_effect=[response(home), response(about)]) as get:
            result = llms.generate_llmstxt('https://example.test/')
        self.assertEqual(result['pages_analyzed'], 1)
        self.assertIn('# Example', result['generated_llmstxt'])
        self.assertIn('About this business', result['generated_llmstxt_full'])
        self.assertEqual([c.args[0] for c in get.call_args_list], ['https://example.test/', 'https://example.test/about'])

    def test_llms_validation_parses_manifest_and_missing_full_version(self):
        text = '# Example\n> A business\n## About\n- [About](https://example.test/about)'
        with patch.object(llms.requests, 'get', side_effect=[response(text), response('', 404)]):
            result = llms.validate_llmstxt('https://example.test/')
        self.assertTrue(result['format_valid'])
        self.assertEqual(result['link_count'], 1)
        self.assertFalse(result['full_version']['exists'])

    def test_reportlab_generates_a_complete_multipage_pdf(self):
        data = {'url': 'https://example.test/', 'brand_name': 'Synthetic audit', 'date': '2026-09-09', 'geo_score': 58,
                'scores': {'ai_citability': 60, 'brand_authority': 45, 'content_eeat': 70, 'technical': 65, 'schema': 30, 'platform_optimization': 50},
                'findings': [{'severity': 'medium', 'title': 'Synthetic finding', 'description': 'Fixture only.'}],
                'quick_wins': ['Review the synthetic finding.']}
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'report.pdf'
            pdf.generate_report(data, str(path))
            content = path.read_bytes()
        self.assertTrue(content.startswith(b'%PDF-'))
        self.assertTrue(content.rstrip().endswith(b'%%EOF'))
        self.assertGreater(content.count(b'/Type /Page'), 2)
        self.assertGreater(len(content), 5000)


if __name__ == '__main__':
    unittest.main()
