import Testing
@testable import VinReadability

private let articleHTML = """
<!DOCTYPE html>
<html>
<head><title>Test Article Title</title></head>
<body>
<article>
<h1>Test Article Title</h1>
<p>By John Doe</p>
<p>This is the first paragraph of a test article. It contains enough text to be considered
readable content by the Readability algorithm. We need several paragraphs to make this work
properly, because Readability looks for substantial content blocks.</p>
<p>This is the second paragraph of the article. It provides additional detail about the topic
being discussed. The content should be long enough that the algorithm considers it worth
extracting as the main article content from the page.</p>
<p>Here is a third paragraph with even more content. Readability uses heuristics to determine
what constitutes the main content of a page, and having multiple paragraphs of reasonable
length helps it identify this section as the article body.</p>
<p>A fourth paragraph continues the discussion. The more content we have, the more confident
the algorithm will be that this is indeed an article worth extracting. This helps ensure
our tests are reliable and not dependent on edge-case behavior.</p>
<p>Finally, a fifth paragraph wraps up the article. This should be more than enough content
for Readability to successfully parse and extract the article, returning a non-nil result
with populated title, content, and textContent fields.</p>
</article>
</body>
</html>
"""

private let minimalHTML = "<html><body><p>Hello</p></body></html>"

@Test func parseArticle() async throws {
    let readability = try await Readability()
    let article = try await readability.parse(html: articleHTML, url: "https://example.com/article")

    #expect(article != nil)
    #expect(article?.title == "Test Article Title")
    #expect(article?.content != nil)
    #expect(article?.content?.isEmpty == false)
    #expect(article?.textContent != nil)
    #expect(article?.textContent?.isEmpty == false)
}

@Test func isProbablyReaderableForArticle() async throws {
    let readability = try await Readability()
    let result = try await readability.isProbablyReaderable(html: articleHTML)
    #expect(result == true)
}

@Test func isProbablyReaderableForMinimalHTML() async throws {
    let readability = try await Readability()
    let result = try await readability.isProbablyReaderable(html: minimalHTML)
    #expect(result == false)
}

@Test func parseReturnsNilForEmptyHTML() async throws {
    let readability = try await Readability()
    let article = try await readability.parse(html: "<html><head></head><body></body></html>")
    #expect(article == nil)
}
