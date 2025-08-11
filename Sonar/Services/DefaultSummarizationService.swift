import Foundation
import NaturalLanguage

struct DefaultSummarizationService: SummarizationService, Sendable {
    func summarize(text: String, maxSentences: Int, toneHint: String?) async -> String {
        let sentences = SentenceSplitter.split(text)
        guard !sentences.isEmpty else { return text }
        // Choose embedding based on device locale; fall back to English; fall back to heuristic if unavailable
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        let language = NLLanguage(languageCode)
        let embedding = Self.embedding(for: language) ?? Self.embedding(for: .english)
        guard let embedding else {
            return text
        }

        let vectors: [[Double]] = sentences.compactMap { embedding.vector(for: $0) }
        guard !vectors.isEmpty else { return text }

        let centroid = VectorOps.centroid(of: vectors)
        let scored: [(String, Double)] = zip(sentences, vectors).map { sentence, vector in
            (sentence, VectorOps.cosine(vector, centroid))
        }
        // Take top-N unique sentences by score, keep original order
        let topSentences = Set(scored.sorted { $0.1 > $1.1 }.prefix(maxSentences).map(\.0))
        let ordered = sentences.filter { topSentences.contains($0) }
        let joined = ordered.joined(separator: " ")
        return Rewriter.rewrite(joined, toneHint: toneHint)
    }

    private static var cache = [NLLanguage: NLEmbedding]()
    private static func embedding(for language: NLLanguage) -> NLEmbedding? {
        if let cached = cache[language] { return cached }
        if let e = NLEmbedding.sentenceEmbedding(for: language) {
            cache[language] = e
            return e
        }
        return nil
    }
}
