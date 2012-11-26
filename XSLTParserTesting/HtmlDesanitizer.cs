using System.Collections.Generic;

namespace XSLTParserTesting
{
    public class HtmlDesanitizer
    {
        public string DesanitizeHtml(string sanitizedHtml, string title)
        {
            if (string.IsNullOrWhiteSpace(sanitizedHtml))
            {
                return "";
            }
            if (string.IsNullOrWhiteSpace(title))
            {
                title = "";
            }
            string[] titleParts = title.Split('.');
            title = titleParts[titleParts.Length - 1];

            var dictionary = new Dictionary<string, string>
                {
                    {"{{replace}}", title},
                    {"&lt;", "<"},
                    {"&gt;", ">"},
                    {"&amp;lt;", "&lt;"},
                    {"&amp;gt;", "&gt;"},
                    {"&amp;", "&"},
                    {"<p>\n  </p>", ""},
                    {"<p></p>", ""}
                };

            string desanitizedHtml = sanitizedHtml;
            foreach (var item in dictionary)
            {
                desanitizedHtml = desanitizedHtml.Replace(item.Key, item.Value);
            }

            return desanitizedHtml;
        }
    }
}