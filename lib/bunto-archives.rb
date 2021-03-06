require 'bunto'

module Bunto
  module Archives
    # Internal requires
    autoload :Archive, 'bunto-archives/archive'
    autoload :VERSION, 'bunto-archives/version'

    if (Bunto.const_defined? :Hooks)
      Bunto::Hooks.register :site, :after_reset do |site|
        # We need to disable incremental regen for Archives to generate with the
        # correct content
        site.regenerator.instance_variable_set(:@disabled, true)
      end
    end

    class Archives < Bunto::Generator
      safe true

      DEFAULTS = {
        'layout' => 'archive',
        'enabled' => [],
        'permalinks' => {
          'year' => '/:year/',
          'month' => '/:year/:month/',
          'day' => '/:year/:month/:day/',
          'tag' => '/tag/:name/',
          'category' => '/category/:name/'
        }
      }

      def initialize(config = nil)
        if config['bunto-archives'].nil?
          @config = DEFAULTS
        else
          @config = Utils.deep_merge_hashes(DEFAULTS, config['bunto-archives'])
        end
      end

      def generate(site)
        @site = site
        @posts = site.posts
        @archives = []

        @site.config['bunto-archives'] = @config

        read
        render
        write

        @site.keep_files ||= []
        @archives.each do |archive|
          @site.keep_files << archive.relative_path
        end
        @site.config["archives"] = @archives
      end

      # Read archive data from posts
      def read
        read_tags
        read_categories
        read_dates
      end

      def read_tags
        if enabled? "tags"
          tags.each do |title, posts|
            @archives << Archive.new(@site, title, "tag", posts)
          end
        end
      end

      def read_categories
        if enabled? "categories"
          categories.each do |title, posts|
            @archives << Archive.new(@site, title, "category", posts)
          end
        end
      end

      def read_dates
        years.each do |year, posts|
          @archives << Archive.new(@site, { :year => year }, "year", posts) if enabled? "year"
          months(posts).each do |month, posts|
            @archives << Archive.new(@site, { :year => year, :month => month }, "month", posts) if enabled? "month"
            days(posts).each do |day, posts|
              @archives << Archive.new(@site, { :year => year, :month => month, :day => day }, "day", posts) if enabled? "day"
            end
          end
        end
      end

      # Checks if archive type is enabled in config
      def enabled?(archive)
        @config["enabled"] == true || @config["enabled"] == "all" || if @config["enabled"].is_a? Array
          @config["enabled"].include? archive
        end
      end

      # Renders the archives into the layouts
      def render
        payload = @site.site_payload
        @archives.each do |archive|
          archive.render(@site.layouts, payload)
        end
      end

      # Write archives to their destination
      def write
        @archives.each do |archive|
          archive.write(@site.dest)
        end
      end

      def tags
        @site.post_attr_hash('tags')
      end

      def categories
        @site.post_attr_hash('categories')
      end

      # Custom `post_attr_hash` method for years
      def years
        hash = Hash.new { |h, key| h[key] = [] }

        # In Bunto 3, Collection#each should be called on the #docs array directly.
        if Bunto::VERSION >= '3.0.0' 
          @posts.docs.each { |p| hash[p.date.strftime("%Y")] << p }
        else
          @posts.each { |p| hash[p.date.strftime("%Y")] << p }
        end
        hash.values.each { |posts| posts.sort!.reverse! }
        hash
      end

      def months(year_posts)
        hash = Hash.new { |h, key| h[key] = [] }
        year_posts.each { |p| hash[p.date.strftime("%m")] << p }
        hash.values.each { |posts| posts.sort!.reverse! }
        hash
      end

      def days(month_posts)
        hash = Hash.new { |h, key| h[key] = [] }
        month_posts.each { |p| hash[p.date.strftime("%d")] << p }
        hash.values.each { |posts| posts.sort!.reverse! }
        hash
      end
    end
  end
end
