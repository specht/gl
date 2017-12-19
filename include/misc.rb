module Miscellaneous
    def run_pager
        # This code is taken from http://nex-3.com/posts/73-git-style-automatic-paging-in-ruby
        # It's not mine, it's from Nathan Weizenbaum. Thanks!
        return if RUBY_PLATFORM =~ /win32/
        return unless STDOUT.tty?
        return if @global_disable_pager

        read, write = IO.pipe

        unless Kernel.fork # Child process
            STDOUT.reopen(write)
            STDERR.reopen(write) if STDERR.tty?
            read.close
            write.close
            return
        end

        # Parent process, become pager
        STDIN.reopen(read)
        read.close
        write.close

        ENV['LESS'] = 'FRX' # Don't page if the input is short enough

        Kernel.select [STDIN] # Wait until we have input before we start the pager
        pager = ENV['PAGER'] || 'less'
        exec pager rescue exec "/bin/sh", "-c", pager
    end

    def wordwrap(s, max_length = 80)
        return s if @global_disable_wordwrap
        in_escape_sequence = false
        line_length = 0
        parts = []
        s.each_char do |c|
            if !in_escape_sequence && c.ord == 0x1b
                in_escape_sequence = true
                parts << ''
            end
            parts << '' if parts.empty?
            parts[-1] += c
            if in_escape_sequence && c.ord == 0x6d
                in_escape_sequence = false
                parts << ''
            end
        end
        parts.reject! { |part| part.empty? }
        parts.map! do |part|
            if part[0].ord == 0x1b
                part
            else
                part.split(/(?<=\s)/)
            end
        end
        parts.flatten!
        parts.map! do |part|
            [part,
            part[0].ord == 0x1b ? 0 : part.size,
            part[0].ord == 0x1b ? false : !!(part[-1] =~ /\s/)
            ]
        end
        spans = [['', 0]]
        parts.each do |part|
            spans[-1][0] += part[0]
            spans[-1][1] += part[1]
            if part[2]
                spans << ['', 0]
            end
        end
        result = ''
        line_length = 0
        spans.each do |span|
            unless line_length + span[1] <= max_length
                result.chop!
                result += "\n"
                line_length = 0
            end
            result += span[0]
            line_length += span[1]
            if span[0].include?("\n")
                line_length = span[0].size - span[0].rindex("\n")
            end
        end
        result
    end

    def indent(s, indent = 4, first_line = true)
        indent_string = ' ' * indent
        first_indent = first_line ? indent_string : ''
        first_indent + s.gsub("\n", "\n" + indent_string)
    end

    def cheading(s, color)
        Paint['== ' + s + ' ' + '=' * ([@screen_width - s.size - 4, 0].max), color]
    end

    def duration(date)
        d = (DateTime.parse(date) - DateTime.now).to_f.ceil
        if d < 0
            d = d.abs
            if d == 1
                "yesterday"
            elsif d < 7
                "#{d} days ago"
            else
                "#{d / 7} weeks ago"
            end
        elsif d > 0
            if d == 1
                "tomorrow"
            elsif d < 7
                "#{d} days from now"
            else
                "#{d / 7} weeks from now"
            end
        else
            "today"
        end
    end

    def unicode_strike_through(s)
        return s if @global_disable_strike
        result = ''
        s.each_char do |c|
            result += c
            result += "\u0336"
        end
        return result
    end
end
