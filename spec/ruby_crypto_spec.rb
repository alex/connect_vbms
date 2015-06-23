require 'spec_helper'

describe "Ruby Encrypt/Decrypt test vs Java reference impl" do
  let (:encrypted_xml) { fixture_path('encrypted_response.xml') }
  let (:plaintext_xml) { fixture_path('plaintext_basic_soap.xml') }
  let (:plaintext_unicode_xml) { fixture_path('plaintext_unicode_soap.xml') }
  let (:plaintext_request_name) { "getDocumentTypes" }
  let (:test_keystore) { fixture_path('test_keystore.jks') }
  let (:test_keystore_pass) { "importkey" }

  it "encrypts in ruby, and decrypts using java" do
    # TODO(awong): Implement encrypt in ruby.
    encrypted_xml = VBMS.encrypted_soap_document(
      plaintext_xml, test_keystore, test_keystore_pass, plaintext_request_name)
    decrypted_xml = VBMS.decrypt_message_xml(encrypted_xml, test_keystore,
                                             test_keystore_pass, plaintext_request_name)

    # Compare the decrypted request node with the original request node.
    original_doc = Nokogiri::XML(fixture('plaintext_basic_soap.xml'))
    original_request_node = original_doc.xpath(
      '/soapenv:Envelope/soapenv:Body/v4:getDocumentTypes',
      VBMS::XML_NAMESPACES)
    decrypted_doc = Nokogiri::XML(decrypted_xml)
    decrypted_request_node = decrypted_doc.xpath(
      '/soapenv:Envelope/soapenv:Body/v4:getDocumentTypes',
      VBMS::XML_NAMESPACES)
    expect(original_request_node).to be_equivalent_to(decrypted_request_node).respecting_element_order
  end

  it "encrypts in java, and decrypts using ruby" do
    # TODO(awong): Implement decrypt in ruby.
    encrypted_xml = VBMS.encrypted_soap_document(
      plaintext_xml, test_keystore, test_keystore_pass, plaintext_request_name)
    decrypted_xml = VBMS.decrypt_message_xml(encrypted_xml, test_keystore,
                                             test_keystore_pass, plaintext_request_name)

    # Compare the decrypted request node with the original request node.
    original_doc = Nokogiri::XML(fixture('plaintext_basic_soap.xml'))
    original_request_node = original_doc.xpath(
      '/soapenv:Envelope/soapenv:Body/v4:getDocumentTypes',
      VBMS::XML_NAMESPACES)
    decrypted_doc = Nokogiri::XML(decrypted_xml)
    decrypted_request_node = decrypted_doc.xpath(
      '/soapenv:Envelope/soapenv:Body/v4:getDocumentTypes',
      VBMS::XML_NAMESPACES)
    expect(original_request_node).to be_equivalent_to(decrypted_request_node).respecting_element_order
  end

  it "handles roundtripping utf-8 content." do
    pending("Correct Unicode Handling")
    encrypted_xml = VBMS.encrypted_soap_document(
      plaintext_unicode_xml, test_keystore, test_keystore_pass, plaintext_request_name)
    decrypted_xml = VBMS.decrypt_message_xml(encrypted_xml, test_keystore,
                                             test_keystore_pass, plaintext_request_name)

    # Compare the decrypted request node with the original request node.
    original_doc = Nokogiri::XML(fixture('plaintext_unicode_soap.xml'))
    original_request_node = original_doc.xpath(
      '/soapenv:Envelope/soapenv:Body/v4:getDocumentTypes',
      VBMS::XML_NAMESPACES)
    decrypted_doc = Nokogiri::XML(decrypted_xml)
    decrypted_request_node = decrypted_doc.xpath(
      '/soapenv:Envelope/soapenv:Body/v4:getDocumentTypes',
      VBMS::XML_NAMESPACES)
    expect(original_request_node).to be_equivalent_to(decrypted_request_node).respecting_element_order
  end
end