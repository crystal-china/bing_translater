class Translater
  class Youdao
    def initialize(session, content, debug_mode, chan, start_time)
      session.navigate_to("https://fanyi.youdao.com/index.html")

      while session.find_by_selector ".pop-up-comp"
        until (element = session.find_by_selector ".pop-up-comp img.close")
          sleep 0.2
        end

        element.click
      end

      until (element1 = session.find_by_selector ".never-show")
        sleep 2
      end

      element1.click

      until (source_content_ele = session.find_by_selector("#js_fanyi_input"))
        sleep 0.2
      end

      source_content_ele.click

      sleep 0.2

      Translater.input(source_content_ele, content)

      if debug_mode
        STDERR.puts "Press any key to continue ..."
        gets
      end

      until result = session.find_by_selector("#js_fanyi_output_resultOutput")
        sleep 0.2
      end

      while result.text.blank?
        sleep 0.2
      end

      text = result.text

      chan.send({text, self.class.name.split(":")[-1], Time.monotonic - start_time})
    rescue Socket::ConnectError
    ensure
      session.delete
    end
  end
end
