using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Xml.Xsl;
using HtmlAgilityPack;

namespace XSLTParserTesting
{
    public class HtmlTransformer
    {
        private IEnumerable<HtmlNode> FollowingSiblingsUntil(HtmlNode start, Func<HtmlNode, bool> predicate)
        {
            var currentNode = start.NextSibling;
            while (currentNode != null && !predicate(currentNode))
            {
                yield return currentNode;
                currentNode = currentNode.NextSibling;
            }
        }

        public string TransformHtml(string html, string title, string xsltFileName)
        {
            // For holding onto links stripped before xsl processing, but which need to be added back.
            var linkCache = new Dictionary<string, string>();

            html = StripMalformedMarkup(html);

            // Load HTML as an HtmlDocument for XSL processing. HtmlDocument is part of the HtmlAgility Pack
            // and is a subclass of the XmlDocument type
            var htmlDocument = new HtmlDocument();
            htmlDocument.LoadHtml(html);
            //htmlDocument = _imageSourceAdjuster.AdjustImageSources(taxUrl, htmlDocument, repoOwner, repoName);
            StripLinks(htmlDocument, linkCache);

            // Load a compiled transform object and set the url to the main content.xslt sheet
            var xslt = new XslCompiledTransform();
            var url = string.Format(@"{0}.xslt", xsltFileName);

            // Perform XSL transformation
            xslt.Load(url);
            var transformed = new StringWriter();
            try
            {
                var headers = htmlDocument.DocumentNode.Descendants("h3").ToList();
                foreach (var header in headers)
                {
                    var siblingsUntil = FollowingSiblingsUntil(header, sibl => sibl.Name == "h2" || sibl.Name == "h3");
                    HtmlNode section = htmlDocument.CreateElement("section");

                    foreach (var sibling in siblingsUntil.ToList())
                    {
                        sibling.ParentNode.RemoveChild(sibling, false);
                        section.AppendChild(sibling);
                    }

                    header.ParentNode.InsertAfter(section, header);
                }

                xslt.Transform(htmlDocument, null, transformed);

                return InsertLinks(transformed.ToString(), linkCache);
            }
            catch (Exception ex)
            {
                StringBuilder messageBuilder = new StringBuilder(string.Format("{0}: {1}\n{2}\n", ex.GetType(), ex.Message, ex.StackTrace));
                if (htmlDocument.ParseErrors.Any())
                {
                    messageBuilder.AppendLine("Reasons for error:");
                    foreach (var parseError in htmlDocument.ParseErrors)
                    {
                        messageBuilder.AppendFormat("Line {0}, Position {1}: {2}\n", parseError.Line, parseError.LinePosition, HttpUtility.HtmlEncode(parseError.Reason));
                    }
                }
                string message = string.Format("Html Transform Error. File {0} incorrect or incomplete.\n{1}", title, messageBuilder);
                throw new HtmlTransformationException(message, ex);
            }
        }

        private void StripLinks(HtmlDocument htmlDoc, Dictionary<string, string> linkCache)
        {
            var links = htmlDoc.DocumentNode.SelectNodes("/blockquote/a | /blockquote/node()/a | /h5/a | /h4/a | /h3/a | /p/a");

            if (links != null)
            {
                var counter = 0;
                foreach (var link in links)
                {
                    var key = string.Format("{{{0}}}", counter);
                    linkCache.Add(key, link.OuterHtml);

                    var newNode = HtmlNode.CreateNode(key);
                    link.ParentNode.ReplaceChild(newNode, link);
                    counter++;
                }
            }
        }

        private string InsertLinks(string transformed, Dictionary<string, string> linkCache)
        {
            foreach (var link in linkCache)
            {
                transformed = transformed.Replace(link.Key, link.Value);
            }
            return transformed;
        }

        private static string StripMalformedMarkup(string html)
        {
            var cleanedMarkup = html;

            var malformedDicionary = new Dictionary<string, string>
            {
                {"<p)", ""},
                {"<T", "&lt;T"},
                {"\\<", "&lt;"},
                {"\\>", "&gt;"}
            };

            foreach (var item in malformedDicionary)
            {
                cleanedMarkup = cleanedMarkup.Replace(item.Key, item.Value);
            }

            return cleanedMarkup;
        }
    }
}