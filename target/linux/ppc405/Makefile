#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=powerpc
BOARD:=ppc405
BOARDNAME:=AMCC/IBM PPC405
CPU_TYPE:=405
SUBTARGETS:=generic
FEATURES:=

KERNEL_PATCHVER:=5.4
KERNEL_TESTING_PATCHVER:=5.10

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES+=

$(eval $(call BuildTarget))
