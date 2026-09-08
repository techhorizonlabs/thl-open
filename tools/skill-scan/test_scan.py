import importlib.util
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch, MagicMock

spec = importlib.util.spec_from_file_location("scan", Path(__file__).with_name("scan.py"))
scan = importlib.util.module_from_spec(spec)
spec.loader.exec_module(scan)


class Finding:
    def to_dict(self):
        return {"rule_id": "NETWORK", "severity": "MEDIUM", "file_path": "/private/host/secret", "line_number": 2,
                "snippet": "private text", "metadata": {"private": True}, "description": "/private/host/secret"}


class ScannerContracts(unittest.TestCase):
    def test_artifacts_omit_absolute_paths_snippets_and_free_form_metadata(self):
        result = scan.sanitized_finding(Finding(), Path("/checkout/skills/example"))
        self.assertEqual(result["file_path"], "[outside-skill-path]")
        self.assertNotIn("private", str(result))
        self.assertEqual(scan.relative_path("scripts/tool.py", Path("/checkout/skills/example")), "skills/example/scripts/tool.py")
        self.assertEqual(scan.relative_path("../outside", Path("/checkout/skills/example")), "[outside-skill-path]")

    def test_errors_and_findings_are_distinct(self):
        class Loader:
            def load_skill(self, path):
                if path.name == "broken":
                    raise ValueError("Sensitive absolute /host/path must not appear")
                return path
        class Analyzer:
            def analyze(self, skill): return [Finding()]
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in ["works", "broken"]:
                (root / "skills" / name).mkdir(parents=True)
                (root / "skills" / name / "SKILL.md").write_text("sample")
            results = scan.scan_skills(root, Loader(), Analyzer())
            self.assertEqual(results[0], {"skill": "broken", "status": "error", "error_type": "ValueError"})
            self.assertEqual(results[1]["status"], "complete")
            self.assertEqual(results[1]["findings"][0]["severity"], "MEDIUM")
            self.assertNotIn("/host/path", str(results))

    def test_target_symlink_is_rejected_before_loader_reads_anything(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "skills" / "example").mkdir(parents=True)
            (root / "skills" / "example" / "SKILL.md").symlink_to(root / "outside")
            with self.assertRaises(ValueError): scan.scan_skills(root, None, None)

    def test_python_guard_covers_network_and_process_events(self):
        for event in scan.BLOCKED_EVENTS:
            with self.assertRaises(RuntimeError): scan.deny_network_and_processes(event, ())
        scan.deny_network_and_processes("open", ())

    def test_linux_boundary_does_not_silently_fall_back(self):
        with patch.object(scan.sys, "platform", "darwin"):
            with self.assertRaises(RuntimeError): scan.check_linux_network_namespace("net:[123]")

    def test_linux_namespace_check_never_reads_another_process_procfs(self):
        import fcntl
        import struct
        def own_namespace_only(path):
            if path != "/proc/self/ns/net":
                raise PermissionError("Other-process namespace is protected")
            return "net:[456]"
        with patch.object(scan.sys, "platform", "linux"), \
             patch.object(scan.os, "readlink", side_effect=own_namespace_only) as readlink, \
             patch.object(scan.socket, "if_nameindex", return_value=[(1, "lo")]), \
             patch.object(scan.socket, "socket", return_value=MagicMock()), \
             patch.object(fcntl, "ioctl", return_value=b"lo".ljust(16, b"\0") + struct.pack("H", 0)):
            self.assertIn("namespace", scan.check_linux_network_namespace("net:[123]"))
            readlink.assert_called_once_with("/proc/self/ns/net")

    def test_namespace_same_as_parent_or_missing_identity_fails_closed(self):
        with patch.object(scan.sys, "platform", "linux"), \
             patch.object(scan.os, "readlink", return_value="net:[123]"):
            for identity in ["net:[123]", None, "invalid"]:
                with self.assertRaises(RuntimeError): scan.check_linux_network_namespace(identity)

    def test_positive_control_detects_attempted_target_execution(self):
        class Loader:
            def load_skill(self, path): return path
        class Analyzer:
            def analyze(self, path):
                (path.parent / "TARGET-WAS-EXECUTED").write_text("FAIL")
                return []
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaises(RuntimeError): scan.positive_control(Loader(), Analyzer(), Path(directory))


if __name__ == "__main__": unittest.main()
