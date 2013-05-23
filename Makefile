# ===============================================================
# Packager for the Confuser tool (https://confuser.codeplex.com/)
# ===============================================================

VERSION?=1.9.0.0
RELEASE?=79258
CERTIFICATE?=Developer ID Installer: Laurent Etiemble

## --------------------
## Variables
## --------------------

BINARIES_DIR=binaries
CONFUSER_DIR=confuser
SUPPORT_DIR=support

CONFUSER_SVN_URL=https://confuser.svn.codeplex.com/svn
CONFUSER_SVN_RELEASE=$(RELEASE)
CONFUSER_SNK=confuser.snk
MONO_GAC_DIR=/Library/Frameworks/Mono.framework/Libraries/mono/gac
MONO_CECIL_MDB=Mono.Cecil.Mdb.dll
PACKAGE_TEMPLATE=Confuser.pmdoc
PACKAGE_PROJECT=Confuser-$(VERSION).pmdoc
PACKAGE_FILE=Confuser-$(VERSION).pkg

# ----------------------------------------
# Targets
# ----------------------------------------

all: \
	checkout \
	patch \
	build \
	package

clean:
	rm -Rf $(CONFUSER_DIR)
	rm -Rf $(BINARIES_DIR)

checkout: $(CONFUSER_DIR)

patch:
	(cd $(CONFUSER_DIR); patch -N -p0 -i ../$(SUPPORT_DIR)/Confuser-$(RELEASE).diff; echo "Done")

build:
	cp $(SUPPORT_DIR)/$(CONFUSER_SNK) $(CONFUSER_DIR)
	xbuild /p:OutputPath=../../$(BINARIES_DIR) $(CONFUSER_DIR)/Confuser.Console/Confuser.Console.csproj
	xbuild /p:OutputPath=../../$(BINARIES_DIR) $(CONFUSER_DIR)/Confuser.MSBuild/Confuser.MSBuild.csproj
	find $(MONO_GAC_DIR) -name "$(MONO_CECIL_MDB)*" -exec cp {} $(BINARIES_DIR) \;

package:
	mkdir -p $(SUPPORT_DIR)/$(PACKAGE_PROJECT)
	sed -e "s/@CERTIFICATE@/$(CERTIFICATE)/g" $(SUPPORT_DIR)/$(PACKAGE_TEMPLATE)/index.xml > $(SUPPORT_DIR)/$(PACKAGE_PROJECT)/index.xml
	sed -e "s/@VERSION@/$(VERSION)/g" $(SUPPORT_DIR)/$(PACKAGE_TEMPLATE)/01binaries.xml > $(SUPPORT_DIR)/$(PACKAGE_PROJECT)/01binaries.xml
	cp $(SUPPORT_DIR)/$(PACKAGE_TEMPLATE)/01binaries-contents.xml $(SUPPORT_DIR)/$(PACKAGE_PROJECT)/01binaries-contents.xml
	/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker --verbose --doc $(SUPPORT_DIR)/$(PACKAGE_PROJECT) -o $(PACKAGE_FILE)

$(CONFUSER_DIR):
	svn co $(CONFUSER_SVN_URL) $(CONFUSER_DIR) -r $(RELEASE)

# ----------------------------------------
# Phony Targets
# ----------------------------------------

.PHONY: \
	all \
	clean \
	checkout \
	patch \
	build \
	package
