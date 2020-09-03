# hl7-cda-signature-verification

I have a HL7 CDA (Clinical Document Architecture) XML document and associated signature XML file.

I need OpenSSL commands that will verify the integrity of the signature.

Attached in this repo a sample CDA XML file and Signature XML file, both are valid files, confirming to the Australian Digital Health Agency's guidance on the structure of these files. The files contain fake data - it is not for a real person. That said, for _these_ files, the signature **is valid**. The outcome I'm looking for is the script/code to verify the integrity of that signature, so it can be run against other CDA files and signatures.

Attached in this repo is:
- The CDA document, named `CDA_ROOT.XML`.
- The signature file, named `CDA_SIGN.VALID.XML`.
- A `guidance.txt` document, linking to various guidance on how to verify the signature. I've tried to understand these, but have been unable to get the result confirming the signature is valid.

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

