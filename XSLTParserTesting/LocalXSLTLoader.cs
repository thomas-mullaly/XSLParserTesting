using System.Web;
using SitefinityWebApp.Modules.GitHubDocs.Core.GitHub.Importer.HTMLTransformation;

namespace XSLTParserTesting
{
    public class LocalXSLTLoader : IXSLTLoader
    {
        public IXslCompiledTransform LoadXSLT(string xsltFileNameWithoutExtension)
        {
            IXslCompiledTransform xslt = new XslCompiledTransformWrapper();
            var url = HttpContext.Current.Server.MapPath(string.Format(@"{0}.xslt", xsltFileNameWithoutExtension));
            xslt.Load(url);
            return xslt;
        }
    }
}