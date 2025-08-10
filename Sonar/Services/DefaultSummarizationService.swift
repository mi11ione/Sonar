import Foundation
import NaturalLanguage

struct DefaultSummarizationService: SummarizationService, Sendable {
    func summarize(text: String, maxSentences: Int, toneHint: String?) async -> String {
        let sentences = SentenceSplitter.split(text)
        // Reuse embedding instance to avoid repeated allocations
        guard !sentences.isEmpty, let embedding = Self.embedding else {
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

    private static let embedding = NLEmbedding.sentenceEmbedding(for: .english)
}
