#!/bin/bash

MONO_DIR=/Library/Frameworks/Mono.framework
MONO_BIN_DIR=$MONO_DIR/Libraries
MONO_LIB_DIR=$MONO_DIR/Libraries
MONO_CONFUSER_DIR=$MONO_LIB_DIR/mono/confuser
MONO_4_0_DIR=$MONO_LIB_DIR/mono/4.0

cp $MONO_CONFUSER_DIR/Confuser.targets $MONO_4_0_DIR
gacutil -i $MONO_CONFUSER_DIR/Confuser.Core.dll
gacutil -i $MONO_CONFUSER_DIR/Confuser.Core.Injections.dll
gacutil -i $MONO_CONFUSER_DIR/Confuser.MSBuild.dll
gacutil -i $MONO_CONFUSER_DIR/Mono.Cecil.dll
gacutil -i $MONO_CONFUSER_DIR/Mono.Cecil.Mdb.dll
gacutil -i $MONO_CONFUSER_DIR/Mono.Cecil.Pdb.dll

ln -s $MONO_CONFUSER_DIR/confuser /usr/bin

echo "Done"
