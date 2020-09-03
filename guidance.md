## Clinical Documents - FAQ Hash value verification v1.0

Available at https://developer.digitalhealth.gov.au/specifications/clinical-documents/ep-2241-2016/nehta-1276-2013

_Note: This is the official guidance from Australian Digital Health Agency._

**Relevant extracts:**

```
The intention of conformance requirement 018634 is to ensure 
that, if a CDA package is downloaded to the local system for 
the purposes of rendering (i.e. viewing or printing), a hash 
value is used to ensure the clinical document has not been 
corrupted while in transit over a network or in storage in 
the local CIS. Therefore,the hash value referred to by this 
requirement is the hash value in the <Manifest> XML element 
of the signature file (CDA_SIGN.XML) used to test the 
integrity of the clinical document (CDA_ROOT.XML), as it is 
the clinical document that is rendered and so the relevant 
hash value is the hash value for the document.

There are a number of hash values associated with a CDA 
package and its contents: 

...

- A hash value within the `<SignedInfo>` XML element is the 
  signature file (`CDA_SIGN.XML`) which is the hash value 
  used to test the integrity of the signature in `CDA_SIGN.XML`.

  The requirement does not refer to the hash value within the 
  `<SignedInfo>` XML element in the signature file; however, a CIS 
  may use this hash value to check the integrity of the signature.

- For all hash values, the Secure Hash Algorithm-1 (SHA-1) is used.
```

_Tim's Notes:_

I _tried_ to implement my understanding of the above via the following,
however the result of calling `verify` is _false_ so I must be comparing 
the wrong fields, or Base64 decoding things I don't need to etc. 
Either way, what I tried doesn't work, yet I know the signature is valid
for the examples:

```ruby
# https://ruby-doc.org/stdlib-2.7.0/libdoc/openssl/rdoc/OpenSSL.html#module-OpenSSL-label-Signatures
cda_sign_file_xml = Nokogiri::XML(File.open(cda_sign_filename)).remove_namespaces!
public_key = OpenSSL::X509::Certificate.new(Base64.decode64(cda_sign_file_xml.css('signedPayload signatures Signature KeyInfo X509Data X509Certificate')&.text.to_s)).public_key
expected_sign_hash = cda_sign_file_xml.css('signedPayload signatures Signature SignedInfo Reference DigestValue')&.text.to_s
signature = Base64.decode64(cda_sign_file_xml.css('signedPayload signatures Signature SignatureValue')&.text.to_s)
puts public_key.verify(OpenSSL::Digest::SHA1.new, signature, expected_sign_hash).inspect # this is returning false, but it should be true
```



-----------



## Maintaining the Integrity of XML Signatures by using the Manifest element
Department Of Computer Science and Computer Engineering, La Trobe University 

_Note: I just found this on Google and it seems relevant_

See `Section VI. CORE VALIDATION` on page 3.

...

Signature validation checks the digest value of `SignedInfo` element with the value stored in `SignatureValue`.

The steps of signature validation for the `SignedInfo` element are:

- Obtain the verification key from the `KeyInfo` element.
- Witb the signature algorithm, compute the signature value over the canonicalized
  `SignedInfo` element and compare it with the value inside the `SignatureValue` element. If they match then signature validation is said to _pass_. 

