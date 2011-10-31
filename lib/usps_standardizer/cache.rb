module USPSStandardizer
  class Cache

    def initialize(store, prefix)
      @store = store
      @prefix = prefix
    end

    def [](url)
      interpret store[key_for(url)]
    end

    def []=(url, value)
      store[key_for(url)] = value
    end

    def expire(url)
      if url == :all
        urls.each{ |u| expire(u) }
      else
        expire_single_url(url)
      end
    end


    private

    attr_reader :prefix, :store

    def key_for(url)
      [prefix, url].join
    end

    def keys
      store.keys.select{ |k| k.match /^#{prefix}/ and interpret(store[k]) }
    end

    def urls
      keys.map{ |k| k[/^#{prefix}(.*)/, 1] }
    end

    def interpret(value)
      value == "" ? nil : value
    end

    def expire_single_url(url)
      store.del(key_for(url))
    end
  end
end
