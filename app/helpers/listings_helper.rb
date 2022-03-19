module ListingsHelper

    # capitalizes every word in string
    def format_condition(condition)
        # condition.gsub("_"," ")
        # arr = condition.split("_").map do |word|
        #     word.capitalize
        # end
        # arr.join(" ")
        # condition.split("_").map(&:capitalize).join(" ")
        condition.split("_").map {|word| word.capitalize}.join(" ")
    end
    def format_price(price)
        "$#{price / 100}"
    end
end


