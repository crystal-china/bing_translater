class Translater
  class Baidu
    def initialize(browser, content, debug_mode, chan, start_time)
      session, driver = Translater.create_driver(browser, debug_mode).not_nil!
      session.navigate_to("https://fanyi.baidu.com/")

      # while session.find_by_selector ".desktop-guide"
      #   until (element = session.find_by_selector "a.desktop-guide-close")
      #     sleep 0.1
      #   end

      #   element.click
      # end

      while (element = session.find_by_selector "div[style*=\"display: block;\"][style^=\"background-color\"]>div>div>span")
        element.click

        sleep 0.1
      end

      # while session.find_by_selector "#app-guide"
      #   until (element = session.find_by_selector "span.app-guide-close")
      #     sleep 0.1
      #   end

      #   element.click
      # end

      # until (source_content_ele = session.find_by_selector("textarea#baidu_translate_input"))
      #   sleep 0.1
      # end

      until (source_content_ele = session.find_by_selector("div[data-slate-node=\"element\""))
        sleep 0.1
      end

      source_content_ele.click

      Translater.input(source_content_ele, content, wait_seconds: 0.1)

      if debug_mode
        STDERR.puts "Press ENTER key to continue ..."
        gets
      end

      # until (result = session.find_by_selector(".output-bd"))
      #   sleep 0.1
      # end

      until (result = session.find_by_selector("span[disabled][spellcheck=\"false\"]"))
        sleep 0.1
      end

      while result.text.blank?
        sleep 0.1
      end

      text = result.text

      chan.send({text, self.class.name.split(":")[-1], Time.monotonic - start_time, browser})
    rescue Socket::ConnectError
    ensure
      session.delete if session
      # driver.stop if driver
    end
  end
end
