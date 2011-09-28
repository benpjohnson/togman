class Mantis
    def initialize (user, password, url)
        @client = Savon::Client.new do |wdsl|
            wdsl.document = url
        end
        @client.wsdl.endpoint = url
        @user = user
        @password = password
    end

    def issue_exists (issue_id)
        user = @user
        password = @password
        issue = @client.request "mc_issue_exists" do 
            soap.body = <<XML 
    <username>#{user}</username>
    <password>#{password}</password>
    <issue_id>#{issue_id}</issue_id>
XML
        end

        issue.to_hash[:mc_issue_exists_response][:return]
    end

    def add_note (issue_id, text, time_tracking)
        user = @user
        password = @password
        res = @client.request "mc_issue_note_add" do 
            soap.body = <<XML 
    <username>#{user}</username>
    <password>#{password}</password>
    <issue_id>#{issue_id}</issue_id>
    <note>
        <text>#{text}</text>
        <view_state>
            <name>private</name>
            <id>50</id>
        </view_state>
        <time_tracking>#{time_tracking}</time_tracking>
    </note>
XML
    end
    end
end
