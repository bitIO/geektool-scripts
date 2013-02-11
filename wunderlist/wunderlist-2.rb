# #########################################
#        wunderlist-display
#
# @author Matthew Cave
# @date Feb 4, 2011
# @abstract Looks up the projects and tasks in your wunderlist.db, and
#   exports them in a ANSI marked up manner appropriate for display in geektool3
# ##########################################

require 'rubygems'
require 'sqlite3'
# ##########################################
# If you are getting errors on the above line
# then you do not have sqlite3 installed correctly
# no matter what gem is telling you. You probably have
# more than one version of ruby installed and
# gem is pointing to a different one than geeltool.
# see the following page for details:
# http://stackoverflow.com/questions/2797020/ruby-gem-not-found-although-it-is-installed
# ###########################################

def relative_indented(str)
  leading_whitespace = str[/\A\s*/]
  str.gsub /^#{leading_whitespace}/ , String.new
end

db = SQLite3::Database.new( "/Library/Containers/com.wunderkinder.wunderlistdesktop/Data/Library/Application Support/Wunderlist/WKModel.sqlite");
db.results_as_hash = true # results returned as a hash, rather than an ordered array
db.type_translation = true # results resurned as their native types (according to the column definition) rather than String

ESCAPE_IMPORTANT_COLOR = "\033[33m"     # defaults to yellow
ESCAPE_PAST_DUE_COLOR = "\033[31m"      # defaults to red
ESCAPE_LIST_TITLE = "\033[32m"          # defaults to red
ESCAPE_PROJECT_NAME_MARKUP = "\033[1m"  # defauls to bold
ESCAPE_NOTE_MARKUP = "\033[3m"          # defaults to italic
ESCAPE_CANCEL = "\033[0m"               # resets all text atributes you may have set
INDENT = "     "

db.execute("select Z_PK, ZTITLE from ZRESOURCE where  ZTASKLIST IS NULL AND Z_ENT = 6 ORDER BY ZORDERINDEXDOUBLE") do |list|
    printedHeader = false
    db.execute("select ZTITLE, ZNOTE, ZSTARRED, ZDUEDATE, ZCREATEDAT from ZRESOURCE where ZTASKLIST=? and ZCOMPLETEDAT is NULL ORDER BY ZORDERINDEXDOUBLE", list['Z_PK']) do |task|

        # There is a task associated with this list, so print the header
        if (printedHeader == false) then
            puts
            puts ESCAPE_PROJECT_NAME_MARKUP + '[LIST] ' + ESCAPE_LIST_TITLE + list['ZTITLE'] + ESCAPE_CANCEL  # this prints a header
            printedHeader = true
        end

        taskToOutput = "[TASK] "

        # if there is a date, print it before the name of the task
        if (!task['ZDUEDATE'].nil? && task['ZDUEDATE'] != 0 ) then
            date = Time.at(task['ZDUEDATE'])
            today = Time.new

            #if the date is in the past, print the date in red
            if (today > date) then
                taskToOutput += INDENT + ESCAPE_PAST_DUE_COLOR + date.month.to_s + "/" + date.day.to_s + "/" + date.year.to_s + ESCAPE_CANCEL + " - "
            else
                taskToOutput += INDENT + date.month.to_s + "/" + date.day.to_s + "/" + date.year.to_s + " - "
            end
        else
            taskToOutput += INDENT
        end

        if (task['ZSTARRED'] == 1) then
          taskToOutput += ESCAPE_IMPORTANT_COLOR + "★ " + ESCAPE_CANCEL
        end
        taskToOutput += task['ZTITLE']

        puts taskToOutput

        # if there is a note, print it in italics
        if (!task['ZNOTE'].nil? && task['ZNOTE'].length > 0) then
          #puts INDENT + INDENT + ESCAPE_NOTE_MARKUP + task['note'] + ESCAPE_CANCEL
          #puts ESCAPE_NOTE_MARKUP + task['note'] + ESCAPE_CANCEL
          lines = task['ZNOTE'].each_line
          lines.each { |line| print INDENT + INDENT + INDENT + ESCAPE_NOTE_MARKUP + line }
          puts ESCAPE_CANCEL
        end # end if (is there a task note)
    end # end do |task| loop
end
