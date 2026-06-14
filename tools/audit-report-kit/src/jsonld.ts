// Compile-checked JSON-LD via schema-dts. If a property is wrong, `tsc`
// fails — that's the point: the schema THL's GEO fixes deploy is type-safe.

import type { Organization, WithContext } from "schema-dts";

export type OrgInput = {
  name: string;
  url: string;
  telephone?: string;
  description?: string;
  logo?: string;
  streetAddress?: string;
  locality?: string;
  region?: string;
  postalCode?: string;
  areaServed?: string[];
  sameAs?: string[];
};

export function generateOrgJsonLd(c: OrgInput): WithContext<Organization> {
  return {
    "@context": "https://schema.org",
    "@type": "Organization",
    name: c.name,
    url: c.url,
    ...(c.telephone ? { telephone: c.telephone } : {}),
    ...(c.description ? { description: c.description } : {}),
    ...(c.logo ? { logo: c.logo } : {}),
    ...(c.streetAddress || c.locality
      ? {
          address: {
            "@type": "PostalAddress",
            ...(c.streetAddress ? { streetAddress: c.streetAddress } : {}),
            ...(c.locality ? { addressLocality: c.locality } : {}),
            ...(c.region ? { addressRegion: c.region } : {}),
            ...(c.postalCode ? { postalCode: c.postalCode } : {}),
            addressCountry: "AU",
          },
        }
      : {}),
    ...(c.areaServed ? { areaServed: c.areaServed } : {}),
    ...(c.sameAs ? { sameAs: c.sameAs } : {}),
  };
}
