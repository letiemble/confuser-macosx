# ===============================================================
# Packager for the Confuser tool (https://confuser.codeplex.com/)
# ===============================================================

VERSION?=1.9.0.0
RELEASE?=79642
CERTIFICATE?=Developer ID Installer: Laurent Etiemble

## --------------------
## Alias
## --------------------

CPC=rsync -ar
RMRF=rm -Rf

## --------------------
## Variables
## --------------------

BINARIES_DIR=binaries
CONFUSER_DIR=confuser
SUPPORT_DIR=support

CONFUSER_SVN_URL=https://confuser.svn.codeplex.com/svn
CONFUSER_SVN_RELEASE=$(RELEASE)
CONFUSER_SNK=confuser.snk
CONFUSER_TARGETS=Confuser.targets
CONFUSER_WRAPPER=confuser
MONO_CONFUSER_DIR=/Library/Frameworks/Mono.framework/Libraries/mono/confuser
PACKAGE_TEMPLATE=Confuser.pmdoc
PACKAGE_PROJECT=Confuser-$(VERSION)_$(RELEASE).pmdoc
PACKAGE_FILE=Confuser-$(VERSION)_$(RELEASE).pkg
MONO_CECIL_SYMBOLS_DIR=$(CONFUSER_DIR)/cecil/symbols
MONO_CECIL_MDB_DIR=$(MONO_CECIL_SYMBOLS_DIR)/mdb
MONO_CECIL_MDB_ZIP=Mono.Cecil.Mdb-0.9.4.0.zip

# ----------------------------------------
# Targets
# ----------------------------------------

all: \
	checkout \
	patch \
	build \
	package

clean:
	$(RMRF) $(CONFUSER_DIR)
	$(RMRF) $(BINARIES_DIR)

checkout: $(CONFUSER_DIR)

patch: checkout $(MONO_CECIL_MDB_DIR)
	(cd $(CONFUSER_DIR); patch -N -p0 -i ../$(SUPPORT_DIR)/Confuser-$(RELEASE).diff; echo "Done");

build: patch
	$(CPC) $(SUPPORT_DIR)/$(CONFUSER_SNK) $(CONFUSER_DIR)
	xbuild /p:OutputPath=../../$(BINARIES_DIR) $(CONFUSER_DIR)/Confuser.Console/Confuser.Console.csproj
	xbuild /p:OutputPath=../../$(BINARIES_DIR) $(CONFUSER_DIR)/Confuser.MSBuild/Confuser.MSBuild.csproj
	$(CPC) $(SUPPORT_DIR)/$(CONFUSER_TARGETS) $(BINARIES_DIR)
	$(CPC) $(SUPPORT_DIR)/$(CONFUSER_WRAPPER) $(BINARIES_DIR)

package: build
	mkdir -p $(SUPPORT_DIR)/$(PACKAGE_PROJECT)
	sed -e "s/@CERTIFICATE@/$(CERTIFICATE)/g" $(SUPPORT_DIR)/$(PACKAGE_TEMPLATE)/index.xml > $(SUPPORT_DIR)/$(PACKAGE_PROJECT)/index.xml
	sed -e "s/@VERSION@/$(VERSION)/g" $(SUPPORT_DIR)/$(PACKAGE_TEMPLATE)/01binaries.xml > $(SUPPORT_DIR)/$(PACKAGE_PROJECT)/01binaries.xml
	$(CPC) $(SUPPORT_DIR)/$(PACKAGE_TEMPLATE)/01binaries-contents.xml $(SUPPORT_DIR)/$(PACKAGE_PROJECT)/01binaries-contents.xml
	/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker --verbose --doc $(SUPPORT_DIR)/$(PACKAGE_PROJECT) -o $(PACKAGE_FILE)

local: build
	sudo cp $(BINARIES_DIR)/* $(MONO_CONFUSER_DIR)
	sudo support/scripts/post_install.sh

$(CONFUSER_DIR):
	svn co $(CONFUSER_SVN_URL) $(CONFUSER_DIR) -r $(RELEASE)

$(MONO_CECIL_MDB_DIR):
	$(CPC) $(SUPPORT_DIR)/$(MONO_CECIL_MDB_ZIP) $(MONO_CECIL_SYMBOLS_DIR)
	(cd $(MONO_CECIL_SYMBOLS_DIR); unzip $(MONO_CECIL_MDB_ZIP); echo "Done");

# ----------------------------------------
# Phony Targets
# ----------------------------------------

.PHONY: \
	all \
	clean \
	checkout \
	patch \
	build \
	package \
	local
