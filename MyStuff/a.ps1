# 2021-02-23 FAJ
#https://paullimblog.wordpress.com/2017/08/08/ps-tip-parsing-html-from-a-local-file-or-a-string/
Set-Location $env:HOMEPATH/desktop
$path="./covid.html"
$html = New-Object -ComObject "HTMLFile"
$html.IHTMLDocument2_write($(Get-Content -path $path -raw))
$html.all.tags("A")| foreach-object innertext
$html.all.tags("A")| out-file "covid.txt"
$html.all|out-file "covid.txt"
$html.all.tags("A")| select-object *
$html.all.tags("external-html")| where-object innertext -like "*new york city*"

$a=($html.allElements|Where-Object {$_.class -match "widget-body flex-fluid full-width flex-vertical overflow-y-auto overflow-x-hidden"}).innerText
$a=($html.allElements|Where-Object {$_.class -match "external-html"}).innerText

$tags=$html.all.tags("")

$url="https://coronavirus.jhu.edu/map.html"
$response = Invoke-WebRequest -Uri $url
$response.ParsedHtml.body.getelementsbyclassname('widget-body flex-fluid full-width flex-vertical overflow-y-auto overflow-x-hidden')





<div class="widget-body flex-fluid full-width flex-vertical overflow-y-auto overflow-x-hidden">
        <nav class="feature-list">
        <span style="" id="ember1041" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>51,809</strong>&nbsp;confirmed</span></p>

<p>New York City&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1043" class="flex-horizontal feature-list-item active ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>11,567</strong>&nbsp;confirmed</span></p>

<p>Westchester&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1045" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>10,587</strong>&nbsp;confirmed</span></p>

<p>Nassau&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1047" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>8,746</strong>&nbsp;confirmed</span></p>

<p>Suffolk&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1049" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>5,575</strong>&nbsp;confirmed</span></p>

<p>Cook&nbsp;<strong><span style="color:#ffffff">Illinois</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1051" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>5,069</strong>&nbsp;confirmed</span></p>

<p>Wayne&nbsp;<strong><span style="color:#ffffff">Michigan</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1053" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>4,866</strong>&nbsp;confirmed</span></p>

<p>Unassigned&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1055" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>4,099</strong>&nbsp;confirmed</span></p>

<p>Bergen&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1057" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>4,045</strong>&nbsp;confirmed</span></p>

<p>Los Angeles&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1059" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>3,751</strong>&nbsp;confirmed</span></p>

<p>Rockland&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1061" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>3,148</strong>&nbsp;confirmed</span></p>

<p>Orleans&nbsp;<strong><span style="color:#ffffff">Louisiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1063" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>2,886</strong>&nbsp;confirmed</span></p>

<p>Miami-Dade&nbsp;<strong><span style="color:#ffffff">Florida</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1065" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>2,656</strong>&nbsp;confirmed</span></p>

<p>King&nbsp;<strong><span style="color:#ffffff">Washington</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1067" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>2,617</strong>&nbsp;confirmed</span></p>

<p>Essex&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1069" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>2,270</strong>&nbsp;confirmed</span></p>

<p>Hudson&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1071" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>2,183</strong>&nbsp;confirmed</span></p>

<p>Oakland&nbsp;<strong><span style="color:#ffffff">Michigan</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1073" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>2,178</strong>&nbsp;confirmed</span></p>

<p>Jefferson&nbsp;<strong><span style="color:#ffffff">Louisiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1075" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>2,132</strong>&nbsp;confirmed</span></p>

<p>Fairfield&nbsp;<strong><span style="color:#ffffff">Connecticut</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1077" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>2,100</strong>&nbsp;confirmed</span></p>

<p>Philadelphia&nbsp;<strong><span style="color:#ffffff">Pennsylvania</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1079" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>2,048</strong>&nbsp;confirmed</span></p>

<p>Orange&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1081" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>2,010</strong>&nbsp;confirmed</span></p>

<p>Union&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1083" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,896</strong>&nbsp;confirmed</span></p>

<p>Suffolk&nbsp;<strong><span style="color:#ffffff">Massachusetts</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1085" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,870</strong>&nbsp;confirmed</span></p>

<p>Middlesex&nbsp;<strong><span style="color:#ffffff">Massachusetts</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1087" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,766</strong>&nbsp;confirmed</span></p>

<p>Middlesex&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1089" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,750</strong>&nbsp;confirmed</span></p>

<p>Passaic&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1091" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,481</strong>&nbsp;confirmed</span></p>

<p>Broward&nbsp;<strong><span style="color:#ffffff">Florida</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1093" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,458</strong>&nbsp;confirmed</span></p>

<p>Monmouth&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1095" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,376</strong>&nbsp;confirmed</span></p>

<p>Snohomish&nbsp;<strong><span style="color:#ffffff">Washington</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1097" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,371</strong>&nbsp;confirmed</span></p>

<p>Ocean&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1099" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,332</strong>&nbsp;confirmed</span></p>

<p>Macomb&nbsp;<strong><span style="color:#ffffff">Michigan</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1101" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,304</strong>&nbsp;confirmed</span></p>

<p>Marion&nbsp;<strong><span style="color:#ffffff">Indiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1103" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,125</strong>&nbsp;confirmed</span></p>

<p>Clark&nbsp;<strong><span style="color:#ffffff">Nevada</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1105" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,082</strong>&nbsp;confirmed</span></p>

<p>Morris&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1107" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,039</strong>&nbsp;confirmed</span></p>

<p>Essex&nbsp;<strong><span style="color:#ffffff">Massachusetts</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1109" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>1,019</strong>&nbsp;confirmed</span></p>

<p>Santa Clara&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1111" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>966</strong>&nbsp;confirmed</span></p>

<p>San Diego&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1113" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>961</strong>&nbsp;confirmed</span></p>

<p>Maricopa&nbsp;<strong><span style="color:#ffffff">Arizona</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1115" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>955</strong>&nbsp;confirmed</span></p>

<p>Harris&nbsp;<strong><span style="color:#ffffff">Texas</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1117" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>938</strong>&nbsp;confirmed</span></p>

<p>Norfolk&nbsp;<strong><span style="color:#ffffff">Massachusetts</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1119" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>869</strong>&nbsp;confirmed</span></p>

<p>Milwaukee&nbsp;<strong><span style="color:#ffffff">Wisconsin</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1121" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>831</strong>&nbsp;confirmed</span></p>

<p>Dallas&nbsp;<strong><span style="color:#ffffff">Texas</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1123" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>747</strong>&nbsp;confirmed</span></p>

<p>Fulton&nbsp;<strong><span style="color:#ffffff">Georgia</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1125" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>737</strong>&nbsp;confirmed</span></p>

<p>Palm Beach&nbsp;<strong><span style="color:#ffffff">Florida</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1127" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>735</strong>&nbsp;confirmed</span></p>

<p>Montgomery&nbsp;<strong><span style="color:#ffffff">Pennsylvania</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1129" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>734</strong>&nbsp;confirmed</span></p>

<p>Erie&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1131" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>712</strong>&nbsp;confirmed</span></p>

<p>St. Louis&nbsp;<strong><span style="color:#ffffff">Missouri</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1133" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>667</strong>&nbsp;confirmed</span></p>

<p>Worcester&nbsp;<strong><span style="color:#ffffff">Massachusetts</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1135" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>667</strong>&nbsp;confirmed</span></p>

<p>Dutchess&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1137" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>665</strong>&nbsp;confirmed</span></p>

<p>Unassigned&nbsp;<strong><span style="color:#ffffff">Georgia</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1139" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>663</strong>&nbsp;confirmed</span></p>

<p>Cuyahoga&nbsp;<strong><span style="color:#ffffff">Ohio</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1141" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>656</strong>&nbsp;confirmed</span></p>

<p>Orange&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1143" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>653</strong>&nbsp;confirmed</span></p>

<p>District of Columbia&nbsp;<strong><span style="color:#ffffff">District of Columbia</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1145" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>647</strong>&nbsp;confirmed</span></p>

<p>New Haven&nbsp;<strong><span style="color:#ffffff">Connecticut</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1147" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>643</strong>&nbsp;confirmed</span></p>

<p>Denver&nbsp;<strong><span style="color:#ffffff">Colorado</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1149" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>638</strong>&nbsp;confirmed</span></p>

<p>Shelby&nbsp;<strong><span style="color:#ffffff">Tennessee</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1151" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>621</strong>&nbsp;confirmed</span></p>

<p>Plymouth&nbsp;<strong><span style="color:#ffffff">Massachusetts</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1153" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>617</strong>&nbsp;confirmed</span></p>

<p>Davidson&nbsp;<strong><span style="color:#ffffff">Tennessee</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1155" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>549</strong>&nbsp;confirmed</span></p>

<p>Somerset&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1157" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>546</strong>&nbsp;confirmed</span></p>

<p>Hampden&nbsp;<strong><span style="color:#ffffff">Massachusetts</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1159" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>542</strong>&nbsp;confirmed</span></p>

<p>Lake&nbsp;<strong><span style="color:#ffffff">Illinois</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1161" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>541</strong>&nbsp;confirmed</span></p>

<p>Orange&nbsp;<strong><span style="color:#ffffff">Florida</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1163" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>539</strong>&nbsp;confirmed</span></p>

<p>Hartford&nbsp;<strong><span style="color:#ffffff">Connecticut</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1165" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>533</strong>&nbsp;confirmed</span></p>

<p>Mecklenburg&nbsp;<strong><span style="color:#ffffff">North Carolina</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1167" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>521</strong>&nbsp;confirmed</span></p>

<p>Dougherty&nbsp;<strong><span style="color:#ffffff">Georgia</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1169" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>501</strong>&nbsp;confirmed</span></p>

<p>Unassigned&nbsp;<strong><span style="color:#ffffff">Washington</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1171" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>498</strong>&nbsp;confirmed</span></p>

<p>Montgomery&nbsp;<strong><span style="color:#ffffff">Maryland</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1173" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>498</strong>&nbsp;confirmed</span></p>

<p>Pierce&nbsp;<strong><span style="color:#ffffff">Washington</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1175" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>493</strong>&nbsp;confirmed</span></p>

<p>Riverside&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1177" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>479</strong>&nbsp;confirmed</span></p>

<p>Lehigh&nbsp;<strong><span style="color:#ffffff">Pennsylvania</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1179" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>476</strong>&nbsp;confirmed</span></p>

<p>Salt Lake&nbsp;<strong><span style="color:#ffffff">Utah</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1181" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>473</strong>&nbsp;confirmed</span></p>

<p>Prince George's&nbsp;<strong><span style="color:#ffffff">Maryland</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1183" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>470</strong>&nbsp;confirmed</span></p>

<p>Delaware&nbsp;<strong><span style="color:#ffffff">Pennsylvania</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1185" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>453</strong>&nbsp;confirmed</span></p>

<p>San Mateo&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1187" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>450</strong>&nbsp;confirmed</span></p>

<p>San Francisco&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1189" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>450</strong>&nbsp;confirmed</span></p>

<p>Bucks&nbsp;<strong><span style="color:#ffffff">Pennsylvania</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1191" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>448</strong>&nbsp;confirmed</span></p>

<p>DuPage&nbsp;<strong><span style="color:#ffffff">Illinois</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1193" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>441</strong>&nbsp;confirmed</span></p>

<p>Arapahoe&nbsp;<strong><span style="color:#ffffff">Colorado</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1195" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>441</strong>&nbsp;confirmed</span></p>

<p>Franklin&nbsp;<strong><span style="color:#ffffff">Ohio</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1197" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>438</strong>&nbsp;confirmed</span></p>

<p>Washtenaw&nbsp;<strong><span style="color:#ffffff">Michigan</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1199" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>424</strong>&nbsp;confirmed</span></p>

<p>Bristol&nbsp;<strong><span style="color:#ffffff">Massachusetts</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1201" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>420</strong>&nbsp;confirmed</span></p>

<p>Monroe&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1203" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>419</strong>&nbsp;confirmed</span></p>

<p>Allegheny&nbsp;<strong><span style="color:#ffffff">Pennsylvania</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1205" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>418</strong>&nbsp;confirmed</span></p>

<p>Providence&nbsp;<strong><span style="color:#ffffff">Rhode Island</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1207" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>409</strong>&nbsp;confirmed</span></p>

<p>DeKalb&nbsp;<strong><span style="color:#ffffff">Georgia</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1209" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>404</strong>&nbsp;confirmed</span></p>

<p>Hillsborough&nbsp;<strong><span style="color:#ffffff">Florida</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1211" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>399</strong>&nbsp;confirmed</span></p>

<p>St. Tammany&nbsp;<strong><span style="color:#ffffff">Louisiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1213" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>386</strong>&nbsp;confirmed</span></p>

<p>Mercer&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1215" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>385</strong>&nbsp;confirmed</span></p>

<p>Jefferson&nbsp;<strong><span style="color:#ffffff">Colorado</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1217" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>384</strong>&nbsp;confirmed</span></p>

<p>Will&nbsp;<strong><span style="color:#ffffff">Illinois</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1219" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>384</strong>&nbsp;confirmed</span></p>

<p>Luzerne&nbsp;<strong><span style="color:#ffffff">Pennsylvania</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1221" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>378</strong>&nbsp;confirmed</span></p>

<p>Northampton&nbsp;<strong><span style="color:#ffffff">Pennsylvania</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1223" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>373</strong>&nbsp;confirmed</span></p>

<p>Alameda&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1225" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>353</strong>&nbsp;confirmed</span></p>

<p>Baltimore&nbsp;<strong><span style="color:#ffffff">Maryland</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1227" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>351</strong>&nbsp;confirmed</span></p>

<p>Blaine&nbsp;<strong><span style="color:#ffffff">Idaho</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1229" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>351</strong>&nbsp;confirmed</span></p>

<p>Travis&nbsp;<strong><span style="color:#ffffff">Texas</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1231" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>349</strong>&nbsp;confirmed</span></p>

<p>Genesee&nbsp;<strong><span style="color:#ffffff">Michigan</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1233" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>343</strong>&nbsp;confirmed</span></p>

<p>Camden&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1235" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>341</strong>&nbsp;confirmed</span></p>

<p>Sacramento&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1237" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>341</strong>&nbsp;confirmed</span></p>

<p>Cobb&nbsp;<strong><span style="color:#ffffff">Georgia</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1239" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>340</strong>&nbsp;confirmed</span></p>

<p>El Paso&nbsp;<strong><span style="color:#ffffff">Colorado</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1241" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>336</strong>&nbsp;confirmed</span></p>

<p>Caddo&nbsp;<strong><span style="color:#ffffff">Louisiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1243" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>332</strong>&nbsp;confirmed</span></p>

<p>Jefferson&nbsp;<strong><span style="color:#ffffff">Alabama</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1245" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>329</strong>&nbsp;confirmed</span></p>

<p>Weld&nbsp;<strong><span style="color:#ffffff">Colorado</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1247" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>328</strong>&nbsp;confirmed</span></p>

<p>Fairfax&nbsp;<strong><span style="color:#ffffff">Virginia</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1249" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>325</strong>&nbsp;confirmed</span></p>

<p>East Baton Rouge&nbsp;<strong><span style="color:#ffffff">Louisiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1251" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>325</strong>&nbsp;confirmed</span></p>

<p>Tarrant&nbsp;<strong><span style="color:#ffffff">Texas</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1253" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>321</strong>&nbsp;confirmed</span></p>

<p>Monroe&nbsp;<strong><span style="color:#ffffff">Pennsylvania</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1255" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>316</strong>&nbsp;confirmed</span></p>

<p>&nbsp;<strong><span style="color:#ffffff">Puerto Rico</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1257" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>314</strong>&nbsp;confirmed</span></p>

<p>Eagle&nbsp;<strong><span style="color:#ffffff">Colorado</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1259" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>307</strong>&nbsp;confirmed</span></p>

<p>Ada&nbsp;<strong><span style="color:#ffffff">Idaho</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1261" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>304</strong>&nbsp;confirmed</span></p>

<p>San Bernardino&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1263" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>303</strong>&nbsp;confirmed</span></p>

<p>Gwinnett&nbsp;<strong><span style="color:#ffffff">Georgia</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1265" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>301</strong>&nbsp;confirmed</span></p>

<p>Onondaga&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1267" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>294</strong>&nbsp;confirmed</span></p>

<p>Burlington&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1269" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>286</strong>&nbsp;confirmed</span></p>

<p>Duval&nbsp;<strong><span style="color:#ffffff">Florida</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1271" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>283</strong>&nbsp;confirmed</span></p>

<p>Barnstable&nbsp;<strong><span style="color:#ffffff">Massachusetts</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1273" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>276</strong>&nbsp;confirmed</span></p>

<p>Contra Costa&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1275" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>275</strong>&nbsp;confirmed</span></p>

<p>Lee&nbsp;<strong><span style="color:#ffffff">Florida</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1277" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>274</strong>&nbsp;confirmed</span></p>

<p>St. John the Baptist&nbsp;<strong><span style="color:#ffffff">Louisiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1279" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>273</strong>&nbsp;confirmed</span></p>

<p>Pinellas&nbsp;<strong><span style="color:#ffffff">Florida</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1281" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>270</strong>&nbsp;confirmed</span></p>

<p>Unassigned&nbsp;<strong><span style="color:#ffffff">Massachusetts</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1283" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>268</strong>&nbsp;confirmed</span></p>

<p>Sumner&nbsp;<strong><span style="color:#ffffff">Tennessee</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1285" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>265</strong>&nbsp;confirmed</span></p>

<p>Baltimore City&nbsp;<strong><span style="color:#ffffff">Maryland</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1287" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>260</strong>&nbsp;confirmed</span></p>

<p>Adams&nbsp;<strong><span style="color:#ffffff">Colorado</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1289" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>254</strong>&nbsp;confirmed</span></p>

<p>Bexar&nbsp;<strong><span style="color:#ffffff">Texas</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1291" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>254</strong>&nbsp;confirmed</span></p>

<p>Denton&nbsp;<strong><span style="color:#ffffff">Texas</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1293" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>253</strong>&nbsp;confirmed</span></p>

<p>Albany&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1295" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>247</strong>&nbsp;confirmed</span></p>

<p>Lafayette&nbsp;<strong><span style="color:#ffffff">Louisiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1297" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>247</strong>&nbsp;confirmed</span></p>

<p>Wake&nbsp;<strong><span style="color:#ffffff">North Carolina</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1299" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>245</strong>&nbsp;confirmed</span></p>

<p>New Castle&nbsp;<strong><span style="color:#ffffff">Delaware</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1301" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>243</strong>&nbsp;confirmed</span></p>

<p>Ulster&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1303" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>240</strong>&nbsp;confirmed</span></p>

<p>Yakima&nbsp;<strong><span style="color:#ffffff">Washington</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1305" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>239</strong>&nbsp;confirmed</span></p>

<p>St. Louis City&nbsp;<strong><span style="color:#ffffff">Missouri</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1307" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>238</strong>&nbsp;confirmed</span></p>

<p>Dane&nbsp;<strong><span style="color:#ffffff">Wisconsin</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1309" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>237</strong>&nbsp;confirmed</span></p>

<p>Pima&nbsp;<strong><span style="color:#ffffff">Arizona</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1311" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>235</strong>&nbsp;confirmed</span></p>

<p>Hennepin&nbsp;<strong><span style="color:#ffffff">Minnesota</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1313" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>231</strong>&nbsp;confirmed</span></p>

<p>Charleston&nbsp;<strong><span style="color:#ffffff">South Carolina</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1315" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>228</strong>&nbsp;confirmed</span></p>

<p>Jefferson&nbsp;<strong><span style="color:#ffffff">Kentucky</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1317" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>226</strong>&nbsp;confirmed</span></p>

<p>Navajo&nbsp;<strong><span style="color:#ffffff">Arizona</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1319" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>221</strong>&nbsp;confirmed</span></p>

<p>Fort Bend&nbsp;<strong><span style="color:#ffffff">Texas</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1321" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>216</strong>&nbsp;confirmed</span></p>

<p>Putnam&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1323" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>216</strong>&nbsp;confirmed</span></p>

<p>Oklahoma&nbsp;<strong><span style="color:#ffffff">Oklahoma</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1325" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>215</strong>&nbsp;confirmed</span></p>

<p>Lake&nbsp;<strong><span style="color:#ffffff">Indiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1327" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>213</strong>&nbsp;confirmed</span></p>

<p>Berkshire&nbsp;<strong><span style="color:#ffffff">Massachusetts</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1329" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>212</strong>&nbsp;confirmed</span></p>

<p>Out of TN&nbsp;<strong><span style="color:#ffffff">Tennessee</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1331" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>211</strong>&nbsp;confirmed</span></p>

<p>Washington&nbsp;<strong><span style="color:#ffffff">Oregon</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1333" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>210</strong>&nbsp;confirmed</span></p>

<p>Chester&nbsp;<strong><span style="color:#ffffff">Pennsylvania</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1335" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>207</strong>&nbsp;confirmed</span></p>

<p>Hamilton&nbsp;<strong><span style="color:#ffffff">Indiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1337" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>207</strong>&nbsp;confirmed</span></p>

<p>Collin&nbsp;<strong><span style="color:#ffffff">Texas</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1339" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>206</strong>&nbsp;confirmed</span></p>

<p>Honolulu&nbsp;<strong><span style="color:#ffffff">Hawaii</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1341" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>206</strong>&nbsp;confirmed</span></p>

<p>Anne Arundel&nbsp;<strong><span style="color:#ffffff">Maryland</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1343" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>206</strong>&nbsp;confirmed</span></p>

<p>Lucas&nbsp;<strong><span style="color:#ffffff">Ohio</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1345" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>204</strong>&nbsp;confirmed</span></p>

<p>Cumberland&nbsp;<strong><span style="color:#ffffff">Maine</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1347" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>204</strong>&nbsp;confirmed</span></p>

<p>Summit&nbsp;<strong><span style="color:#ffffff">Utah</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1349" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>203</strong>&nbsp;confirmed</span></p>

<p>Lancaster&nbsp;<strong><span style="color:#ffffff">Pennsylvania</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1351" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>201</strong>&nbsp;confirmed</span></p>

<p>Ascension&nbsp;<strong><span style="color:#ffffff">Louisiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1353" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>200</strong>&nbsp;confirmed</span></p>

<p>Richland&nbsp;<strong><span style="color:#ffffff">South Carolina</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1355" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>199</strong>&nbsp;confirmed</span></p>

<p>Williamson&nbsp;<strong><span style="color:#ffffff">Tennessee</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1357" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>192</strong>&nbsp;confirmed</span></p>

<p>Mahoning&nbsp;<strong><span style="color:#ffffff">Ohio</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1359" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>184</strong>&nbsp;confirmed</span></p>

<p>Washoe&nbsp;<strong><span style="color:#ffffff">Nevada</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1361" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>182</strong>&nbsp;confirmed</span></p>

<p>Spokane&nbsp;<strong><span style="color:#ffffff">Washington</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1363" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>181</strong>&nbsp;confirmed</span></p>

<p>St. Bernard&nbsp;<strong><span style="color:#ffffff">Louisiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1365" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>180</strong>&nbsp;confirmed</span></p>

<p>St. Charles&nbsp;<strong><span style="color:#ffffff">Louisiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1367" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>179</strong>&nbsp;confirmed</span></p>

<p>Sussex&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1369" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>178</strong>&nbsp;confirmed</span></p>

<p>Collier&nbsp;<strong><span style="color:#ffffff">Florida</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1371" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>178</strong>&nbsp;confirmed</span></p>

<p>Unassigned&nbsp;<strong><span style="color:#ffffff">Michigan</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1373" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>178</strong>&nbsp;confirmed</span></p>

<p>Hamilton&nbsp;<strong><span style="color:#ffffff">Ohio</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1375" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>177</strong>&nbsp;confirmed</span></p>

<p>Ventura&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1377" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>177</strong>&nbsp;confirmed</span></p>

<p>Chittenden&nbsp;<strong><span style="color:#ffffff">Vermont</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1379" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>175</strong>&nbsp;confirmed</span></p>

<p>Whatcom&nbsp;<strong><span style="color:#ffffff">Washington</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1381" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>174</strong>&nbsp;confirmed</span></p>

<p>Unassigned&nbsp;<strong><span style="color:#ffffff">Connecticut</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1383" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>173</strong>&nbsp;confirmed</span></p>

<p>San Joaquin&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1385" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>171</strong>&nbsp;confirmed</span></p>

<p>Douglas&nbsp;<strong><span style="color:#ffffff">Colorado</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1387" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>170</strong>&nbsp;confirmed</span></p>

<p>Osceola&nbsp;<strong><span style="color:#ffffff">Florida</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1389" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>170</strong>&nbsp;confirmed</span></p>

<p>Rockingham&nbsp;<strong><span style="color:#ffffff">New Hampshire</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1391" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>169</strong>&nbsp;confirmed</span></p>

<p>Gloucester&nbsp;<strong><span style="color:#ffffff">New Jersey</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1393" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>168</strong>&nbsp;confirmed</span></p>

<p>Berks&nbsp;<strong><span style="color:#ffffff">Pennsylvania</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1395" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>165</strong>&nbsp;confirmed</span></p>

<p>Clayton&nbsp;<strong><span style="color:#ffffff">Georgia</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1397" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>164</strong>&nbsp;confirmed</span></p>

<p>Marion&nbsp;<strong><span style="color:#ffffff">Oregon</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1399" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>163</strong>&nbsp;confirmed</span></p>

<p>Coconino&nbsp;<strong><span style="color:#ffffff">Arizona</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1401" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>163</strong>&nbsp;confirmed</span></p>

<p>Hillsborough&nbsp;<strong><span style="color:#ffffff">New Hampshire</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1403" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>163</strong>&nbsp;confirmed</span></p>

<p>Bernalillo&nbsp;<strong><span style="color:#ffffff">New Mexico</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1405" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>161</strong>&nbsp;confirmed</span></p>

<p>Johnson&nbsp;<strong><span style="color:#ffffff">Kansas</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1407" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>160</strong>&nbsp;confirmed</span></p>

<p>Multnomah&nbsp;<strong><span style="color:#ffffff">Oregon</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1409" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>158</strong>&nbsp;confirmed</span></p>

<p>Kern&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1411" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>158</strong>&nbsp;confirmed</span></p>

<p>Lafourche&nbsp;<strong><span style="color:#ffffff">Louisiana</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1413" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>156</strong>&nbsp;confirmed</span></p>

<p>Sullivan&nbsp;<strong><span style="color:#ffffff">New York</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1415" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>155</strong>&nbsp;confirmed</span></p>

<p>Durham&nbsp;<strong><span style="color:#ffffff">North Carolina</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1417" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>155</strong>&nbsp;confirmed</span></p>

<p>Summit&nbsp;<strong><span style="color:#ffffff">Ohio</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1419" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>154</strong>&nbsp;confirmed</span></p>

<p>Kane&nbsp;<strong><span style="color:#ffffff">Illinois</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1421" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>154</strong>&nbsp;confirmed</span></p>

<p>Greenville&nbsp;<strong><span style="color:#ffffff">South Carolina</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1423" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>153</strong>&nbsp;confirmed</span></p>

<p>Bartow&nbsp;<strong><span style="color:#ffffff">Georgia</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1425" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>153</strong>&nbsp;confirmed</span></p>

<p>Skagit&nbsp;<strong><span style="color:#ffffff">Washington</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1427" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>152</strong>&nbsp;confirmed</span></p>

<p>Howard&nbsp;<strong><span style="color:#ffffff">Maryland</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1429" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>151</strong>&nbsp;confirmed</span></p>

<p>Tulsa&nbsp;<strong><span style="color:#ffffff">Oklahoma</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1431" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>148</strong>&nbsp;confirmed</span></p>

<p>Unassigned&nbsp;<strong><span style="color:#ffffff">Nevada</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1433" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>145</strong>&nbsp;confirmed</span></p>

<p>Seminole&nbsp;<strong><span style="color:#ffffff">Florida</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1435" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>144</strong>&nbsp;confirmed</span></p>

<p>Unassigned&nbsp;<strong><span style="color:#ffffff">Colorado</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1437" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>141</strong>&nbsp;confirmed</span></p>

<p>Litchfield&nbsp;<strong><span style="color:#ffffff">Connecticut</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
        <span style="" id="ember1439" class="flex-horizontal feature-list-item ember-view"><!----><!----><div class="flex-fluid list-item-content overflow-hidden ">
  <div class="external-html">
    <p><span style="color:#e60000"><strong>139</strong>&nbsp;confirmed</span></p>

<p>Santa Barbara&nbsp;<strong><span style="color:#ffffff">California</span>&nbsp;</strong>US</p>

  </div>
</div>
</span>
    </nav>

  </div>