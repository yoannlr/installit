#!/bin/sh

GNOME_VERSION="$(gnome-shell --version | grep -Eo '[0-9]+\.[0-9]+$' | cut -d '.' -f 1)"

# some help from https://unix.stackexchange.com/a/707840
install_extension_id() {
	EXTENSION_ID="$1"
	VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=${EXTENSION_ID}" | jq ".extensions[] | select(.uuid == \"${EXTENSION_ID}\") | .shell_version_map | to_entries[] | select(.key | startswith(\"${GNOME_VERSION}\")) | .value.pk" | sort -n | tail -n 1)
	echo "Installing extension $EXTENSION_ID version $VERSION_TAG"
	wget -O "${EXTENSION_ID}.zip" "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
	gnome-extensions install --force "${EXTENSION_ID}.zip"
	if ! gnome-extensions list | grep --quiet "${EXTENSION_ID}"; then
		busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s "${EXTENSION_ID}"
	fi
	gnome-extensions enable "${EXTENSION_ID}"
	rm "${EXTENSION_ID}.zip"
	echo "Extension installed"
}

#install_extension_url() {
#	EXTENSION_ID=$(curl -s "$1" | grep -oP 'data-uuid="\K[^"]+')
#	install_extension_id "$EXTENSION_ID"
#}
#install_extension_url "https://extensions.gnome.org/extension/3843/just-perfection/"

# install extensions

install_extension_id "just-perfection-desktop@just-perfection"
install_extension_id "undecorate@tabdeveloper.com"
install_extension_id "caffeine@patapon.info"
install_extension_id "remove-alt-tab-delay@daase.net"
install_extension_id "notification-banner-reloaded@marcinjakubowski.github.com"
install_extension_id "legacyschemeautoswitcher@joshimukul29.gmail.com"
install_extension_id "gsconnect@andyholmes.github.io"

sudo apt install gnome-shell-extension-manager

# configure shell and extensions

gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier '<Super>'
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button 'true'

gsettings set org.gnome.mutter attach-modal-dialogs 'false'
gsettings set org.gnome.mutter center-new-windows 'true'
gsettings set org.gnome.mutter auto-maximize 'false'
gsettings set org.gnome.mutter check-alive-timeout 60000

gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll 'false'
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click 'true'

# file manager
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>x']"

# close windows with super+q
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"

# alt-tab = switch windows, not apps
gsettings set org.gnome.desktop.wm.keybindings switch-windows "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"

# extension configurations
gsettings set org.gnome.shell.extensions.caffeine show-indicator 'never'
gsettings set org.gnome.shell.extensions.notification-banner-reloaded anchor-horizontal 1 # right
gsettings set org.gnome.shell.extensions.notification-banner-reloaded animation-direction 1 # slide from right
gsettings set org.gnome.shell.extensions.just-perfection activities-button 'false' # no "activities" button (less clutter on top bar)
gsettings set org.gnome.shell.extensions.just-perfection startup-status 0 # start on desktop
gsettings set org.gnome.shell.extensions.just-perfection window-demands-attention-focus 'true' # no "window is ready"
gsettings set org.gnome.shell.extensions.just-perfection animation 3 # faster animations
