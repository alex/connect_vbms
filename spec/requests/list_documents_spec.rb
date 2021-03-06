require "spec_helper"

describe VBMS::Requests::ListDocuments do
  describe "soap_doc" do
    subject { VBMS::Requests::ListDocuments.new("123456788") }

    it "generates valid SOAP" do
      xml = subject.soap_doc.to_xml
      xsd = Nokogiri::XML::Schema(fixture("soap.xsd"))
      expect(xsd.errors).to eq []
      errors = xsd.validate(parse_strict(xml))
      expect(errors).to eq []
    end
  end

  describe "parsing the XML response" do
    before(:all) do
      request = VBMS::Requests::ListDocuments.new("784449089")
      xml = fixture("requests/list_documents.xml")
      doc = parse_strict(xml)
      @vbms_docs = request.handle_response(doc)
    end

    subject { @vbms_docs }

    it "should return an array of Document objects" do
      expect(subject).to be_an(Array)
      expect(subject).to all(be_a(VBMS::Responses::Document))
      expect(subject.count).to eq(179) # how many are in sample file
    end

    it "should load the fields properly into the document record" do
      doc = subject.first

      expect(doc.document_id).to eq("{9E364101-AFDD-49A7-A11F-602CCF2E5DB5}")
      expect(doc.filename).to eq("tmp20150506-94244-6zotzp")
      expect(doc.doc_type).to eq("356")
      expect(doc.source).to eq("VHA_CUI")
    end

    it "should parse the dates correctly" do
      expect(subject[0].received_at).to eq(Date.parse("2015-05-06-04:00"))
      expect(subject[1].received_at).to eq(Date.parse("2014-11-13-05:00"))
    end
  end
end
