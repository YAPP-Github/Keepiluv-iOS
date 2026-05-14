import ProjectDescription

public extension TargetScript {
    /// Firebase Crashlytics dSYM 업로드 스크립트입니다.
    ///
    /// Archive 빌드 시 생성된 dSYM을 Firebase Console에 업로드해 크래시 스택을 심볼화합니다.
    /// SPM 기준 경로를 사용하며, `basedOnDependencyAnalysis: false`로 항상 실행됩니다.
    /// Tuist는 SPM 패키지를 Tuist/.build/checkouts/에 관리합니다.
    /// `run` 대신 `upload-symbols`를 직접 호출해 dSYM 경로와 GoogleService-Info.plist를 명시합니다.
    static let crashlyticsUploadSymbols = TargetScript.post(
        script: """
        UPLOAD_SYMBOLS=$(find "$SRCROOT" -name "upload-symbols" -path "*/Crashlytics/*" 2>/dev/null | head -1)
        if [ -z "$UPLOAD_SYMBOLS" ]; then
            UPLOAD_SYMBOLS=$(find "$SRCROOT/../.." -maxdepth 6 -name "upload-symbols" -path "*/Crashlytics/*" 2>/dev/null | head -1)
        fi

        if [ -z "$UPLOAD_SYMBOLS" ]; then
            echo "warning: Firebase Crashlytics upload-symbols not found. Run tuist install."
            exit 0
        fi

        "$UPLOAD_SYMBOLS" \
          -gsp "$SRCROOT/Resources/GoogleService-Info.plist" \
          -p ios \
          "$DWARF_DSYM_FOLDER_PATH/$DWARF_DSYM_FILE_NAME"
        """,
        name: "Firebase Crashlytics",
        basedOnDependencyAnalysis: false
    )
}
