module Findable

    def find_by_name(name)
        self.all.select {|a|a.name.include?(name.split.map(&:capitalize).join(' '))}
    end  

    def find_by_url(profile_url)
        self.all.detect {|a|a.profile_url==profile_url}
    end

end

module Setable

    def include_attributes(attributes)
        attributes.each {|att,v|self.send("#{att}=",v)}
    end

end