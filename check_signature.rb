#! /bin/ruby
# this just checks the document signature matches that in the signature file, not the integrity of the signature itself

cda_sign_file_xml = Nokogiri::XML(cda_sign_filename).remove_namespaces!

expected_root_hash = cda_sign_file_xml.css('signedPayload signedPayloadData eSignature Manifest Reference[URI="CDA_ROOT.XML"] DigestValue')&.text.to_s
actual_root_hash = Digest::SHA1.base64digest(File.read(cda_root_filename))&.to_s

raise (expected_root_hash == actual_root_hash).inspect
