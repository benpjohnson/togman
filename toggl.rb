class Toggl
    def initialize (api_key, nonbill)
        @api_key = api_key
        @nonbill = nonbill

        @sess = Patron::Session.new
        @sess.base_url = "https://www.toggl.com"
        @sess.username = api_key
        @sess.password = "api_token"
    end

    def today
        from = Time.utc(Time.now.year, Time.now.month, Time.now.day).iso8601
        to = Time.utc(Time.now.year, Time.now.month, Time.now.day, 23, 59, 59).iso8601
        return self.entries(from, to)
    end

    def entries (from, to)
        log = {}
        res = @sess.get('/api/v5/time_entries.json?start_date=' + from + '&end_date=' + to).body
        JSON.parse(res)["data"].each do |item|
            raw = item["description"]

            # Check all entries start with a issue number
            if !res = raw.match(/^([0-9]+) (.+)$/)
                raise 'Item does not have an issue number: ' + raw
            end

            ims  = res[1]
            desc = res[2]
            duration = (item["duration"] / 60)

            if log[ims] == nil
                log[ims] = []
            end

            # Squash times with the same descriptions together
            exists = false
            log[ims].each do |exist|
                if exist[:desc] == desc
                    exist[:duration] += duration
                    exists = true
                end
            end

            free = false
            if !@nonbill.member? ims.to_i
                orig = duration
                duration = ((duration.to_f/10).ceil*10).round
                free = true
            end

            if !exists
                log[ims].push({:desc => desc, :duration => duration, :orig => orig})
             end
        end
        return log
    end
end
