Product Requirements Document (PRD)
Project Name: WalScribe CMS
Team Name: Tribe
Date: September 2, 2025


## Product Overview
WalScribe CMS is a Web3-powered Content Management System designed for creators, brands, and businesses who want to publish, manage, and monetize content without central control. Built on the Sui Ecosystem, it leverages Sui’s object-centric model, low latency, and high throughput to offer ownership, transparency, and monetization for digital content.

Tagline: “Create. Own. Monetize. On-Chain.”

## Objectives

•	Decentralize content publishing – remove reliance on centralized servers and platforms.
•	Enable digital ownership – each content (article, video and image).
•	Empower creators – transparent monetization, and royalty enforcement.
•	User-first experience – intuitive CMS interface with the feel of WordPress/Medium, powered by Walrus under the hood.
3. Target Users
•	Independent Creators – writers, musicians, visual artists, podcasters.
•	Web3 Communities/DAOs – publishing updates, reports, governance content.
•	Brands/Startups – marketing, gated reports, premium content.
•	Educators – E-learning materials.

##Key Features

Content Management
•	Create, edit, and publish posts (text, video, audio, graphics).
•	Rich text editor with markdown + media embedding.
•	Versioning and history stored immutably.
On-Chain Ownership
•	Each published item minted as an NFT on Sui.
•	Creators hold cryptographic proof of ownership.
•	Support for royalties and resale rights.
Access Control
•	Token-gated content (only users holding certain NFTs/tokens can view).
•	Subscription tiers (monthly/annual) using SUI or stablecoins. (In-View)
•	One-time purchase for premium content. (In-View)
Monetization
•	Direct crypto payments (SUI, USDC on Sui).
•	Creator royalties enforced by Sui smart contracts.
•	Optional free content with ad/NFT sponsorship.
User Features
•	Wallet integration and zkLogin: Slush(Sui Wallet).
•	Profile/dashboard for creators and subscribers.
•	Commenting & community features with on-chain identity (SuiNS).
Infra & Admin
•	Decentralized storage: Walrus.
•	CMS dashboard with analytics (views, likes, purchases)
5. User Flows
Example: Creator Publishing Flow
Connect wallet → authenticate.
Create content (upload text/media).
Choose monetization model: free, gated, paid NFT.
CMS mints content NFT on Sui.
Content distributed with unique on-chain ID.
Example: Reader Flow
Visit WalScribe CMS site.
Browse content (public + gated).
Connect wallet if access needed.
Purchase NFT subscription / token for gated access.

## Technical Requirements

•	Blockchain: Sui
•	Smart Contracts: Move language for NFT minting, royalty enforcement, token gating.
•	Frontend: React + Tailwind + Next.js
•	Backend: Move Language
•	Storage: Walrus.
•	Payments: SUI, USDC on Sui.
•	Wallets Supported: Sui Wallet(Slush).
7. Security Considerations
•	No hardcoding of private keys (use wallets).
•	Encrypted metadata for private content.
•	Validate wallet addresses before transfers.
•	Enforce content access via on-chain smart contract checks.
•	Role-based permissions (creator, moderator, admin).
8. Success Metrics
•	Creator adoption: number of creators onboarded.
•	User retention: repeat visits & content engagement.
•	Revenue generated: total crypto payments processed.
•	Content NFTs minted: volume of published works on-chain.
9. Roadmap (Phased Delivery)
Phase 1 (MVP):
•	Wallet connect (Sui Wallet).
•	Content publishing + NFT minting.
•	Basic token gating.
•	IPFS storage integration.
Phase 2:
•	Multi-wallet support.
•	Subscription tiers + royalty smart contracts.
•	Analytics dashboard.
•	UI polish + theming.
Phase 3:
•	Mobile-first experience.
•	Advanced monetization (ads, sponsorship NFTs).
•	Integration with SuiNS for identity.
Things we are already Work On
- Users will be able to login using Wallet Connect and ZKLogin for easy user experience.
- Users can create, edit and delete post.
- Users can manage posts.
- Users can view analytics of their site usage.