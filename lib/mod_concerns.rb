module Findable

    def find_by_name(name)
        # binding.pry
        self.all.select {|a|a.name.include?(name.split.map(&:capitalize).join(' '))}
    end  

end