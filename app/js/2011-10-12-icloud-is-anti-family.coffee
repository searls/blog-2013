@postScripts ||= {}
@postScripts.iCloudIsAntiFamily = ->
  convertSemanticGirlsAndBoys = ->
    $("article td").html (i, oldHtml) ->
      newHtml = "#{iconify(oldHtml, "[x]", "her")}#{iconify(oldHtml, "[y]", "him")}" || oldHtml

  iconify = (source, code, klass) ->
    (if source.indexOf(code) isnt -1 then "<span class=\"icon " + klass + "\"></span>" else "")

  stripTrailingPipesFromMarkdownTables = ->
    $("article td:last-child").each (i, el) ->
      text = $(el).text()
      $(el).text text.replace("|", "")  if text.indexOf("|") isnt -1
      $(el).addClass "success"  if text.indexOf("Yes") isnt -1
      $(el).addClass "failure"  if text.indexOf("No") isnt -1


  appendCss = ->
    $("""
      <style type="text/css">
        .success {
          color: #4E9600;
          font-weight: bold;
        }
        .failure {
          color: #A62500;
          font-weight: bold;
        }
        .icon {
          display: inline-block;
          width: 16px;
          height: 16px;
        }
        .her {
          background: url('/img/user_female.png') no-repeat;
        }

        .him {
          background: url('/img/user.png') no-repeat;
        }
      </style>
      """).appendTo "head"

  (($) ->
    convertSemanticGirlsAndBoys()
    stripTrailingPipesFromMarkdownTables()
    appendCss()
  ) jQuery
