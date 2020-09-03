# hl7-cda-signature-verification

I have a HL7 CDA (Clinical Document Architecture) XML document and associated signature XML file.

I need OpenSSL commands that will verify the integrity of the signature.

Attached in this repo a sample CDA XML file and Signature XML file, both are valid files, confirming to the Australian Digital Health Agency's guidance on the structure of these files. The files contain fake data - it is not for a real person. That said, for _these_ files, the signature **is valid**. The outcome I'm looking for is the script/code to verify the integrity of that signature, so it can be run against other CDA files and signatures.

Attached in this repo is:
- The CDA document, named `CDA_ROOT.XML`.
- The signature file, named `CDA_SIGN.VALID.XML`.
- A `guidance.md` document, linking to various guidance on how to verify the signature. I've tried to understand these, but have been unable to get the result confirming the signature is valid.

Out of scope:
- You do **not** need to confirm the signature is valid for the `CDA_ROOT.XML` file. I've already confirmed that with the following Ruby code.

```
    cda_sign_file_xml = Nokogiri::XML(File.open(cda_sign_filename)).remove_namespaces!

    expected_root_hash = cda_sign_file_xml.css('signedPayload signedPayloadData eSignature Manifest Reference[URI="CDA_ROOT.XML"] DigestValue')&.text.to_s
    actual_root_hash = Digest::SHA1.base64digest(File.read(cda_root_filename))&.to_s
    
    puts expected_root_hash == actual_root_hash # returns true
```

In scope:
- What's I'm wanting to confirm _in this job_ is the integrity of the signature itself using OpenSSL commands I can run on Debian that has OpenSSL version 1.1.1d  10 Sep 2019.

### The signature files come from:

"Additional files to be used in CIS vendor tests" section of: https://developer.digitalhealth.gov.au/resources/faqs/secure-messaging-provider-directory-service-message-payload#test-data

The following MDM-T02 messages should be used for these tests: [.hl7 Updated 11 March 2020]
- MP-5.1 SHA-1 – valid signature use: [MDMT02-SHA1-Valid](https://developer.digitalhealth.gov.au/sites/default/files/mdmt02-sha1-valid.hl7)
- MP-5.2 SHA-1 – invalid signature use: [MDMT02-SHA1-Invalid](https://developer.digitalhealth.gov.au/sites/default/files/mdmt02-sha1-invalid.hl7)
- MP-5.3 SHA-2 – valid signature use: [MDMT02-SHA2-Valid](https://developer.digitalhealth.gov.au/sites/default/files/mdmt02-sha2-valid.hl7)
- MP-5.4 SHA-2 – invalid signature use: [MP-5.4 SHA-2 – invalid signature](https://developer.digitalhealth.gov.au/sites/default/files/mdmt02-sha2-invalid.hl7)
