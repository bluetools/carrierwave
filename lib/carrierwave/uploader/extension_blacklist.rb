# encoding: utf-8

module CarrierWave
  module Uploader
    module ExtensionBlacklist
      extend ActiveSupport::Concern

      included do
        before :cache, :check_blacklist!
      end

      ##
      # Override this method in your uploader to provide a black list of extensions which
      # are allowed to be uploaded. Compares the file's extension case insensitive.
      # Furthermore, not only strings but Regexp are allowed as well.
      #
      # When using a Regexp in the black list, `\A` and `\z` are automatically added to
      # the Regexp expression, also case insensitive.
      #
      # === Returns
      #
      # [NilClass, Array[String,Regexp]] a black list of extensions which are not allowed to be uploaded
      #
      # === Examples
      #
      #     def extension_black_list
      #       %w(bat cmd vb vbs)
      #     end
      #
      # Basically the same, but using a Regexp:
      #
      #     def extension_black_list
      #       [/vbs?/, 'bat', 'cmd']
      #     end
      #
      def extension_black_list; end

    private

      def check_blacklist!(new_file)
        extension = new_file.extension.to_s
        if extension_black_list and extension_black_list.detect { |item| extension =~ /\A#{item}\z/i }
          raise CarrierWave::IntegrityError, I18n.translate(:"errors.messages.extension_black_list_error", :extension => new_file.extension.inspect)
        end
      end

    end # ExtensionBlacklist
  end # Uploader
end # CarrierWave
