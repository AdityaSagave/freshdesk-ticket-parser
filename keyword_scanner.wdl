WebAutomation.LaunchChrome.LaunchChrome Url: $'''https://landaueraushelp.freshdesk.com/a/dashboard/default''' WindowState: WebAutomation.BrowserWindowState.Maximized ClearCache: False ClearCookies: False WaitForPageToLoadTimeout: 60 Timeout: 60 PiPUserDataFolderMode: WebAutomation.PiPUserDataFolderModeEnum.AutomaticProfile TargetDesktop: $'''{\"DisplayName\":\"Local computer\",\"Route\":{\"ServerType\":\"Local\",\"ServerAddress\":\"\"},\"DesktopType\":\"local\"}''' BrowserInstance=> Browser
WAIT 10
WebAutomation.ExtractData.ExtractList BrowserInstance: Browser Control: $'''html > body > div:eq(7) > div:eq(1) > div:eq(1) > div:eq(1) > div > div > div > div:eq(1) > div > div:eq(0) > div > div:eq(2) > div > div > div > table > tbody > tr''' ExtractionParameters: {[$'''td > div > div:eq(0)''', $'''Own Text''', $'''(?<=#)\\d{6}'''] } PostProcessData: True TimeoutInSeconds: 60 ExtractedData=> DataFromWebPage
Display.ShowMessageDialog.ShowMessage Title: $'''First email''' Message: DataFromWebPage[0] Icon: Display.Icon.None Buttons: Display.Buttons.OK DefaultButton: Display.DefaultButton.Button1 IsTopMost: False ButtonPressed=> firstEmailID
LOOP FOREACH link IN DataFromWebPage
    WebAutomation.GoToWebPage.GoToWebPageCloseDialog BrowserInstance: Browser Url: $'''https://landaueraushelp.freshdesk.com/a/tickets/%link%''' WaitForPageToLoadTimeout: 60
    WebAutomation.ExtractData.ExtractSingleValue BrowserInstance: Browser ExtractionParameters: {[$'''html > body > div:eq(7) > div:eq(1) > div:eq(1) > div:eq(1) > div:eq(0) > div:eq(0) > div > div > div > div:eq(0) > div > div:eq(7) > div > div:eq(1) > div > div > div:eq(1) > div:eq(1) > div''', $'''Own Text''', $''''''] } TimeoutInSeconds: 60 ExtractedData=> emailBody
    ON ERROR

    END
    Text.ParseText.RegexParseForFirstOccurrence Text: emailBody TextToFind: $'''\\b(fetal|urgent|asap|current)\\b''' StartingPosition: 0 IgnoreCase: True OccurrencePosition=> Position Match=> Match
    IF IsNotEmpty(Match) THEN
        Display.ShowMessageDialog.ShowMessage Title: $'''This email contain imp keyword''' Message: $'''Imp keyword: %Match%
Ticket ID: %link%
Email Body: %emailBody%''' Icon: Display.Icon.Information Buttons: Display.Buttons.OK DefaultButton: Display.DefaultButton.Button1 IsTopMost: False ButtonPressed=> ButtonPressed2
    END
END
WebAutomation.CloseWebBrowser BrowserInstance: Browser
