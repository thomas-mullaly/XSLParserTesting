using System;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using MarkdownSharp;
using SitefinityWebApp.Modules.GitHubDocs.Core.Documentation;
using SitefinityWebApp.Modules.GitHubDocs.Core.GitHub.Importer;
using SitefinityWebApp.Modules.GitHubDocs.Core.GitHub.Importer.HTMLTransformation;

namespace XSLTParserTesting
{
    public partial class _Default : Page
    {
        private readonly IHtmlTransformer _htmlTransformer = new HtmlTransformer(new ImageSourceAdjuster(), new LocalXSLTLoader(), 
            new MalformedHTMLStripper(), new SectionHtmlTagWrapper(), new HtmlHyperlinkStripper());
        protected void Page_Load(object sender, EventArgs e)
        {
            ErrorLabel.Visible = false;
            ErrorLabel.Text = "";
            if (IsPostBack)
            {
                ConvertedHTMLPanel.Visible = ShowHTMLOutputCheckbox.Checked;
                ConvertedXSLTPanel.Visible = ShowXSLTOutputCheckbox.Checked;
                HandleUpload();
            }
            else
            {
                ConvertedHTMLPanel.Visible = false;
                ConvertedXSLTPanel.Visible = false;
            }
        }

        private void HandleUpload()
        {
            if (!MarkdownFileInput.PostedFile.FileName.EndsWith(".md"))
            {
                ShowError("Please post a Markdown file (file ending in md extension).");
                return;
            }
            var streamReader = new StreamReader(MarkdownFileInput.PostedFile.InputStream);
            string markdownFileContents = streamReader.ReadToEnd();
            string html = ShowMarkdownAndGetHTML(markdownFileContents);
            ShowXSLTParsedHTML(html);
        }

        private void ShowXSLTParsedHTML(string html)
        {
            string transformed;
            try
            {
                transformed = _htmlTransformer.TransformHtml(html, MarkdownFileInput.PostedFile.FileName, XSLTFileDDL.SelectedValue.ToLower());
            }
            catch (HtmlTransformationException ex)
            {
                ShowError(ex.Message.Replace("\n", "<br />"));
                return;
            }
            XSLTParsedLiteral.Text = new HtmlDesanitizer().DesanitizeHtml(transformed, MarkdownFileInput.PostedFile.FileName);
        }

        private string ShowMarkdownAndGetHTML(string markdownFileContents)
        {
            string[] splitContents = markdownFileContents.Split(new[] {"---"}, StringSplitOptions.RemoveEmptyEntries);
            var contentsToConvert = splitContents.Last();
            var converter = new Markdown(new MarkdownOptions { EmptyElementSuffix = "/>" });
            var html = converter.Transform(contentsToConvert);
            MarkdownMetadataLiteral.Text = splitContents.First().Replace("\n", "<br />");
            HTMLFromMarkdownLiteral.Text = HttpUtility.HtmlEncode(html).Replace("\n", "<br />");

            return html;
        }

        private void ShowError(string message)
        {
            ConvertedXSLTPanel.Visible = false;
            ConvertedHTMLPanel.Visible = false;
            ErrorLabel.Visible = true;
            ErrorLabel.Text = message;
        }
    }
}
