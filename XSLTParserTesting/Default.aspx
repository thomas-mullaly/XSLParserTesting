<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="XSLTParserTesting._Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:Label runat="server" ID="ErrorLabel" Visible="False" CssClass="error" />
    <p>
        <input id="MarkdownFileInput" runat="server" type="file" />
    </p>
    <p>
        <asp:DropDownList runat="server" ID="XSLTFileDDL">
            <asp:ListItem>API</asp:ListItem>
            <asp:ListItem>Prose</asp:ListItem>
        </asp:DropDownList>
        <label for="<%= XSLTFileDDL.ClientID %>">XSLT File</label>
    </p>
    <p>
        <asp:CheckBox runat="server" ID="ShowHTMLOutputCheckbox" Text="Show HTML Output" Checked="True" />
    </p>
    <p>
        <asp:CheckBox runat="server" ID="ShowXSLTOutputCheckbox" Text="Show XSLT Output" Checked="True" />
    </p>
    <p>
        <input type="submit" value="Test Markdown" />
    </p>
    <asp:Panel runat="server" ID="ConvertedHTMLPanel" Visible="False">
        <h2>Markdown File Metadata</h2>
        <asp:Literal runat="server" ID="MarkdownMetadataLiteral" />
        <h2>HTML converted from Markdown file</h2>
        <asp:Literal runat="server" ID="HTMLFromMarkdownLiteral" />
    </asp:Panel>
    <asp:Panel runat="server" ID="ConvertedXSLTPanel" Visible="True">
        <h2>After running through XSLT</h2>
        <asp:Literal runat="server" ID="XSLTParsedLiteral" />
    </asp:Panel>
</asp:Content>
