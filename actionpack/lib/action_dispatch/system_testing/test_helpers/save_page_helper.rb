# frozen_string_literal: true

module ActionDispatch
  module SystemTesting
    module TestHelpers
      # Save page helper for saving the HTML in system tests.
      module SavePageHelper
        # Saves the HTML of the current page in the browser.
        #
        # +save_page+ can be used at any point in your system tests to save
        # the HTML of the current page. This can be useful for debugging.
        #
        # The HTML path will be displayed in your console, if supported.
        def save_page
          save_html
          puts display_html
        end

        # Saves the HTML of the current page in the browser if the test
        # failed.
        #
        # +save_failed_page_html+ is included in <tt>application_system_test_case.rb</tt>
        # that is generated with the application. To save the page when a test
        # fails add +save_failed_page_html+ to the teardown block before clearing
        # sessions.
        def save_failed_page_html
          save_html if failed? && supports_save_page?
        end

        private
          def html_name
            failed? ? "failures_#{method_name}" : method_name
          end

          def html_path
            @html_path ||= absolute_html_path.relative_path_from(Pathname.pwd).to_s
          end

          def absolute_html_path
            Rails.root.join("tmp/html/#{html_name}.html")
          end

          def save_html
            page.save_page(absolute_html_path)
          end

          def display_html
            message = "[HTML]: #{html_path}\n".dup
          end

          def failed?
            !passed? && !skipped?
          end

          def supports_save_page?
            Capybara.current_driver != :rack_test
          end
      end
    end
  end
end
