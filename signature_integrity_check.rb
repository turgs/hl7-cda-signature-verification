#! /bin/ruby


require "nokogiri"
require "openssl"
require "base64"

# Constants
C14N    = Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0
NS_MAP  = {
  "c14n"  => "http://www.w3.org/2001/10/xml-exc-c14n#",
  "ds"    => "http://www.w3.org/2000/09/xmldsig#",
  "xsi"   => "http://www.w3.org/2001/XMLSchema-instance",
  "xs"    => "http://www.w3.org/2001/XMLSchema",
  "elch"  => "http://ns.electronichealth.net.au/xsp/xsd/SignedPayload/2010",
}

SHA_MAP = {
  1    => OpenSSL::Digest::SHA1,
  256  => OpenSSL::Digest::SHA256,
  384  => OpenSSL::Digest::SHA384,
  512  => OpenSSL::Digest::SHA512
}

# Read the document
document = Nokogiri::XML(File.read("CDA_SIGN.XML"))
prefix = "/elch:signedPayload/elch:signatures"

# Get and set up the certificate
certificate_str = document.at("#{prefix}/ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509Certificate", NS_MAP).text
decoded = Base64.decode64(certificate_str)
certificate = OpenSSL::X509::Certificate.new(decoded)

# Read the signature
signature = document.at("#{prefix}/ds:Signature", NS_MAP)

# Canonicalization: Stringify the node in a nice way
node = document.at("#{prefix}/ds:Signature/ds:SignedInfo", NS_MAP)
canoned = node.canonicalize(C14N)

# Figure out which method has been used to the sign the node
signature_method = OpenSSL::Digest::SHA1
if signature.at("./ds:SignedInfo/ds:SignatureMethod/@Algorithm", NS_MAP).text =~ /sha(\d+)$/
  signature_method = SHA_MAP[$1.to_i]
end

# Read the signature
signature_value = signature.at("./ds:SignatureValue", NS_MAP).text
decoded_signature_value = Base64.decode64(signature_value);

# Finally, verify that the signature is correct
verify = certificate.public_key.verify(signature_method.new, decoded_signature_value, canoned)
if verify
  print "Signature is correct\n"
else
  print "Signature is incorrect\n"
end

