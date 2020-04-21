#!/bin/sh

ECLIPSE_DIR=$1
WORKSPACE_DIR=$2

make_pref() {
    local PREF_DIR=$1
    local PREF_FILE=$2
    if [ ! -e "$PREF_DIR" ]; then
	mkdir -p "$PREF_DIR"
    fi
    if [ ! -f "$PREF_DIR/$PREF_FILE" ]; then
	echo "eclipse.preferences.version=1" >> $PREF_DIR/$PREF_FILE
    fi
}

add_pref() {
    local PREF_DIR=$1
    local PREF_FILE=$2
    local PREF=$3
    local VALUE=$4

    if [ ! -f "$PREF_DIR/$PREF_FILE" ]; then
	make_pref $PREF_DIR $PREF_FILE
    fi
    echo "$PREF=$VALUE" >> $PREF_DIR/$PREF_FILE
}



# 自動更新をオフ [設定]-[インストール/更新]-[自動更新]
disable_autoupdate() {
    DIR="$ECLIPSE_DIR/p2/org.eclipse.equinox.p2.engine/profileRegistry/epp.package.java.profile/.data/.settings"
    PREFS="org.eclipse.equinox.p2.ui.sdk.scheduler.prefs"
    add_pref $DIR $PREFS enabled false
}

# 起動時にワークスペースを選択するダイアログを表示しないように設定
# [設定]-[一般]-[開始およびシャットダウン]-[ワークスペース]
disable_workspacedialog() {
    DIR="$ECLIPSE_DIR/configuration/.settings"
    PREFS="org.eclipse.ui.ide.prefs"
    add_pref $DIR $PREFS MAX_RECENT_WORKSPACES 10
    # Issue: 2つの絶対パス $ECLIPSE_DIR, $WORKSPACE_DIR から相対パスを求める
    add_pref $DIR $PREFS RECENT_WORKSPACES ../workspace
    add_pref $DIR $PREFS RECENT_WORKSPACES_PROTOCOL 3
    add_pref $DIR $PREFS SHOW_RECENT_WORKSPACES false
    add_pref $DIR $PREFS SHOW_WORKSPACE_SELECTION_DIALOG false
}

# 起動時のようこそ画面をオフ
disable_welcome() {
    DIR="$WORKSPACE_DIR/.metadata/.plugins/org.eclipse.core.runtime/.settings"
    PREFS="org.eclipse.ui.prefs"
    add_pref $DIR $PREFS showIntro false
}

# デフォルト文字コードをUTF8に
# [設定]-[一般]-[ワークスペース]
encoding_utf8() {
    DIR="$WORKSPACE_DIR/.metadata/.plugins/org.eclipse.core.runtime/.settings"
    PREFS="org.eclipse.core.resources.prefs"
    add_pref $DIR $PREFS encoding UTF-8
    add_pref $DIR $PREFS version 1
}

# 通知を無効化
# [設定]-[一般]-[通知]
disable_notification() {
    DIR="$WORKSPACE_DIR/.metadata/.plugins/org.eclipse.core.runtime/.settings"
    PREFS="org.eclipse.mylyn.commons.notifications.ui.prefs"
    add_pref $DIR $PREFS notifications.enabled false
}

# Drag & Drop編集を無効化
# [一般]-[エディター]-[テキスト・エディター]
disable_draganddrop() {
    DIR="$WORKSPACE_DIR/.metadata/.plugins/org.eclipse.core.runtime/.settings"
    PREFS="org.eclipse.ui.editors.prefs"
    add_pref $DIR $PREFS textDragAndDropEnabled false
}

# スペルチェックを無効化
# [一般]-[エディター]-[テキスト・エディター]-[スペル]
disable_spellcheck() {
    DIR="$WORKSPACE_DIR/.metadata/.plugins/org.eclipse.core.runtime/.settings"
    PREFS="org.eclipse.ui.editors.prefs"
    add_pref $DIR $PREFS spellingEnabled false
}

# 空白文字を可視化
# [一般]-[エディター]-[テキスト・エディター]
show_whitespace() {
    DIR="$WORKSPACE_DIR/.metadata/.plugins/org.eclipse.core.runtime/.settings"
    PREFS="org.eclipse.ui.editors.prefs"
    add_pref $DIR $PREFS showLeadingSpaces  false  # 空白（先頭）
    add_pref $DIR $PREFS showEnclosedSpaces false  # 空白（囲い）
    add_pref $DIR $PREFS showTrailingSpaces false  # 空白（末尾）
    # add_pref $DIR $PREFS showLeadingIdeographicSpaces  false  # 全角空白（先頭）
    # add_pref $DIR $PREFS showEnclosedIdeographicSpaces false  # 全角空白（囲い）
    # add_pref $DIR $PREFS showTrailingIdeographicSpaces false  # 全角空白（末尾）
    # add_pref $DIR $PREFS showLeadingTabs  false  # タブ（先頭）
    add_pref $DIR $PREFS showEnclosedTabs   false  # タブ（囲い）
    add_pref $DIR $PREFS showTrailingTabs   false  # タブ（末尾）
    add_pref $DIR $PREFS showLineFeed       false  # 復帰
    add_pref $DIR $PREFS showCarriageReturn false  # 改行
    add_pref $DIR $PREFS showWhitespaceCharacters true
    # 全角空白および先頭のタブのみ可視化
}

# 終了時に確認しない
# [一般]-[開始およびシャットダウン]
disable_exitprompt() {
    DIR="$WORKSPACE_DIR/.metadata/.plugins/org.eclipse.core.runtime/.settings"
    PREFS="org.eclipse.ui.ide.prefs"
    add_pref $DIR $PREFS EXIT_PROMPT_ON_CLOSE_LAST_WINDOW false
}

# 起動時のプラグインを全てオフ
# [一般]-[開始およびシャットダウン]
disable_startupplugins() {
    DIR="$WORKSPACE_DIR/.metadata/.plugins/org.eclipse.core.runtime/.settings"
    PREFS="org.eclipse.ui.workbench.prefs"
    add_pref $DIR $PREFS PLUGINS_NOT_ACTIVATED_ON_STARTUP \
	     "org.eclipse.buildship.stsmigration;org.eclipse.egit.ui;org.eclipse.epp.logging.aeri.ide;org.eclipse.epp.mpc.ui;org.eclipse.equinox.p2.ui.sdk.scheduler;org.eclipse.m2e.discovery;org.eclipse.mylyn.builds.ui;org.eclipse.mylyn.tasks.ui;org.eclipse.mylyn.team.ui;org.eclipse.oomph.setup.ui;org.eclipse.oomph.workingsets.editor;org.eclipse.ui.monitoring;"
}

# フォントをconsolas
# [一般]-[外観]-[色とフォント]
set_editorfont() {
    DIR="$WORKSPACE_DIR/.metadata/.plugins/org.eclipse.core.runtime/.settings"
    PREFS=org.eclipse.ui.workbench.prefs
    FONT="1|Consolas|11.25|0|WINDOWS|1|-15|0|0|0|400|0|0|0|0|3|2|1|49|Consolas;"

    add_pref $DIR $PREFS org.eclipse.compare.contentmergeviewer.TextMergeViewer $FONT
    add_pref $DIR $PREFS org.eclipse.debug.ui.DetailPaneFont $FONT
    add_pref $DIR $PREFS org.eclipse.debug.ui.MemoryViewTableFont $FONT
    add_pref $DIR $PREFS org.eclipse.debug.ui.consoleFont $FONT
    add_pref $DIR $PREFS org.eclipse.egit.ui.CommitMessageEditorFont $FONT
    add_pref $DIR $PREFS org.eclipse.egit.ui.CommitMessageFont $FONT
    add_pref $DIR $PREFS org.eclipse.egit.ui.DiffHeadlineFont $FONT
    add_pref $DIR $PREFS org.eclipse.jdt.internal.ui.compare.JavaMergeViewer $FONT
    add_pref $DIR $PREFS org.eclipse.jdt.internal.ui.compare.PropertiesFileMergeViewer $FONT
    add_pref $DIR $PREFS org.eclipse.jdt.ui.PropertiesFileEditor.textfont $FONT
    add_pref $DIR $PREFS org.eclipse.jdt.ui.editors.textfont $FONT
    add_pref $DIR $PREFS org.eclipse.jface.textfont $FONT
    add_pref $DIR $PREFS org.eclipse.mylyn.wikitext.ui.presentation.textFont $FONT
    add_pref $DIR $PREFS org.eclipse.recommenders.snipmatch.rcp.searchTextFont $FONT
    add_pref $DIR $PREFS org.eclipse.wst.sse.ui.textfont $FONT
}

# ニュースフィードを止める
# [一般]-[ニュース]
disable_newsfeed() {
    DIR="$WORKSPACE_DIR/.metadata/.plugins/org.eclipse.core.runtime/.settings"
    PREFS="org.eclipse.recommenders.news.rcp.prefs"
    add_pref $DIR $PREFS newsEnabled false
    add_pref $DIR $PREFS feed.list.sorted \
	     "!org.eclipse.recommenders.rcp.feed.ide;!org.eclipse.epp.package.feed.eclipseNews"
    add_pref $DIR $PREFS custom.feed.list.sorted []
}

# プロジェクト・フォルダーをソースおよびクラス・ファイルのルートとして使用
# [Java]-[ビルド・パス]
use_projectfolder() {
    DIR="$WORKSPACE_DIR/.metadata/.plugins/org.eclipse.core.runtime/.settings"
    PREFS="org.eclipse.jdt.ui.prefs"
    add_pref $DIR $PREFS org.eclipse.jdt.ui.wizards.srcBinFoldersInNewProjects false
}

disable_autoupdate
disable_workspacedialog
disable_welcome
encoding_utf8
disable_notification
disable_draganddrop
disable_spellcheck
show_whitespace
disable_exitprompt
disable_startupplugins
set_editorfont
disable_newsfeed
use_projectfolder

exit 0
