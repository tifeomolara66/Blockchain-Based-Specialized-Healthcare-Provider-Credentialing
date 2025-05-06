# MedCred: Blockchain-Based Specialized Healthcare Provider Credentialing

![MedCred Logo](https://via.placeholder.com/150x150)

## Overview

MedCred is a revolutionary blockchain-based platform that transforms the healthcare provider credentialing process. By leveraging distributed ledger technology, MedCred creates a secure, transparent, and efficient ecosystem for managing healthcare practitioner credentials, reducing administrative burden while enhancing trust and compliance.

The platform addresses the significant challenges in traditional credentialing:
- Eliminating redundant verification processes across multiple healthcare organizations
- Reducing credentialing timelines from months to days
- Creating a single source of truth for provider qualifications
- Enhancing security and preventing credential fraud
- Streamlining regulatory compliance
- Enabling real-time monitoring of credential status changes

MedCred serves all healthcare ecosystem stakeholders: practitioners, healthcare organizations, payers, regulatory bodies, and ultimately patients, who benefit from increased trust in provider qualifications.

## Core Smart Contracts

MedCred's functionality is powered by five interconnected smart contracts:

### 1. Provider Identity Contract

The foundation of the credentialing system, managing comprehensive practitioner profiles:

- Creates immutable, self-sovereign professional identities
- Implements W3C Decentralized Identifiers (DIDs) and Verifiable Credentials standards
- Stores biographic information, specialty designations, and practice details
- Manages identity attestations from trusted authorities
- Provides comprehensive audit trails of profile changes
- Supports advanced privacy controls with granular permission management

```solidity
// Sample function from Provider Identity Contract
function createProviderIdentity(
    address providerAddress,
    bytes32 nationalProviderIdentifier,
    string calldata specialtyCode,
    bytes32 demographicDataHash,
    bytes calldata providerSignature
) external returns (bytes32 providerDID);
```

### 2. Education Verification Contract

Validates and maintains records of medical education and training:

- Records medical school, residency, fellowship, and continuing education
- Integrates with educational institution verification services
- Tracks board certifications with expiration monitoring
- Validates specialty training and qualifications
- Stores cryptographic proofs of educational documentation
- Manages revocation capabilities for educational institutions

```solidity
// Sample function from Education Verification Contract
function verifyEducation(
    bytes32 providerDID,
    bytes32 institutionDID,
    string calldata degreeType,
    string calldata specialty,
    uint256 completionDate,
    bytes32 transcriptHash,
    bytes calldata institutionSignature
) external returns (bytes32 educationCredentialId);
```

### 3. License Tracking Contract

Monitors professional licenses and authorizations in real-time:

- Tracks medical licenses across multiple jurisdictions
- Implements automated expiration alerts and renewal workflows
- Integrates with state medical boards for direct verification
- Records disciplinary actions and restrictions
- Supports primary source verification requirements
- Enables cross-state license recognition for telehealth applications

```solidity
// Sample function from License Tracking Contract
function registerLicense(
    bytes32 providerDID,
    string calldata licenseType,
    string calldata licenseNumber,
    string calldata issuingAuthority,
    uint256 issueDate,
    uint256 expirationDate,
    bytes32 documentHash,
    bytes calldata boardSignature
) external returns (bytes32 licenseId);
```

### 4. Privileging Contract

Manages clinical privileges and approved medical procedures:

- Records hospital-specific privileging decisions
- Tracks procedure-specific authorizations
- Implements privileging request and approval workflows
- Manages temporary, emergency, and disaster privileges
- Supports FPPE (Focused Professional Practice Evaluation) and OPPE (Ongoing Professional Practice Evaluation) processes
- Enables rapid privileges verification during patient care

```solidity
// Sample function from Privileging Contract
function grantPrivilege(
    bytes32 providerDID,
    bytes32 facilityDID,
    bytes32 procedureCode,
    uint8 privilegeLevel,
    uint256 effectiveDate,
    uint256 expirationDate,
    bytes32[] calldata evidenceHashes,
    bytes calldata approverSignature
) external returns (bytes32 privilegeId);
```

### 5. Peer Review Contract

Facilitates secure and confidential quality assessment by colleagues:

- Manages confidential peer review processes
- Implements blinded review protocols for objectivity
- Supports structured quality metrics and assessment tools
- Records clinical outcome data while preserving privacy
- Enables cross-institutional peer review collaboration
- Ensures compliance with peer review protection statutes

```solidity
// Sample function from Peer Review Contract
function submitPeerReview(
    bytes32 reviewerDID,
    bytes32 subjectDID,
    bytes32 reviewTypeId,
    bytes32 encryptedReviewHash,
    uint256 reviewDate,
    bytes32[] calldata caseReferenceIds,
    bytes calldata reviewerSignature
) external returns (bytes32 reviewId);
```

## Technical Architecture

MedCred is built on a robust technical foundation designed for healthcare's unique requirements:

### Blockchain Layer
- Primary chain: Enterprise Ethereum/Hyperledger Fabric/Quorum
- Private transactions for sensitive credentialing data
- Role-based permissions aligned with healthcare hierarchies
- HIPAA-compliant data management

### Data Management
- On-chain: Credential verification status, timestamps, and access controls
- Off-chain: Encrypted credential documentation with secure storage
- Zero-knowledge proofs for credential verification without revealing sensitive details

### Interoperability Framework
- FHIR (Fast Healthcare Interoperability Resources) compatibility
- HL7 messaging support for healthcare system integration
- DirectTrust integration for secure provider communications
- SAML/OpenID Connect for authentication

### Security Features
- Multi-factor authentication requirements
- Hardware security module integration
- Comprehensive audit logging
- Advanced encryption for data at rest and in transit
- Compliance with HIPAA, HITECH, and regional healthcare privacy laws

## Getting Started

### Prerequisites
- Node.js (v16+)
- Truffle Suite or Hardhat
- Access to target healthcare blockchain network
- PKI infrastructure for digital signatures

### Installation

1. Clone the repository:
```bash
git clone https://github.com/medcred/platform.git
cd platform
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment:
```bash
cp .env.example .env
# Edit .env with your network configuration and API keys
```

4. Compile smart contracts:
```bash
npx hardhat compile
```

5. Deploy to your chosen network:
```bash
npx hardhat run scripts/deploy.js --network <network_name>
```

6. Initialize system with trusted authorities:
```bash
npx hardhat run scripts/initialize-authorities.js --network <network_name>
```

### Configuration Options

MedCred can be customized for different healthcare environments:

```javascript
// config.js example
module.exports = {
  // Provider identity configuration
  providerIdentity: {
    requiredFields: ["NPI", "DEA", "specialty", "contactInformation"],
    optionalFields: ["biography", "languages", "researchInterests"],
    verificationLevel: "STRICT" // or "STANDARD", "MINIMAL"
  },
  
  // Education verification configuration
  educationVerification: {
    requireDirectInstitutionVerification: true,
    allowProvisionalCredentialing: false,
    internationalMedicalGraduateRequirements: ["ECFMG", "equivalencyEvaluation"]
  },
  
  // License tracking configuration
  licenseTracking: {
    automaticVerification: true,
    verificationFrequency: 30, // days
    expirationWarningPeriod: 90 // days
  },
  
  // Privileging configuration
  privileging: {
    standardPrivilegeCategories: ["diagnostic", "therapeutic", "surgical"],
    temporaryPrivilegeValidity: 120, // days
    emergencyPrivilegeWorkflow: "expedited" // or "standard"
  },
  
  // Peer review configuration
  peerReview: {
    anonymizationLevel: "DOUBLE_BLIND", // or "SINGLE_BLIND", "OPEN"
    minimumReviewersRequired: 3,
    reviewCycleFrequency: 180 // days
  }
};
```

## Usage Examples

### Complete Provider Credentialing Workflow

```javascript
const ProviderIdentity = await ethers.getContractFactory("ProviderIdentity");
const EducationVerification = await ethers.getContractFactory("EducationVerification");
const LicenseTracking = await ethers.getContractFactory("LicenseTracking");
const Privileging = await ethers.getContractFactory("Privileging");
const PeerReview = await ethers.getContractFactory("PeerReview");

// Deploy and connect contracts
const identityContract = await ProviderIdentity.deploy();
const educationContract = await EducationVerification.deploy(identityContract.address);
const licenseContract = await LicenseTracking.deploy(identityContract.address);
const privilegingContract = await Privileging.deploy(
  identityContract.address,
  educationContract.address,
  licenseContract.address
);
const peerReviewContract = await PeerReview.deploy(
  identityContract.address,
  privilegingContract.address
);

// 1. Create provider identity
const providerWallet = ethers.Wallet.createRandom();
const providerNPI = "1234567890";
const providerSpecialty = "cardiology";
const demographicHash = ethers.utils.id(JSON.stringify({
  name: "Dr. Jane Smith",
  contact: "jane.smith@hospital.org",
  birthDate: "1980-06-15"
}));

// Provider signs their demographic data to prove ownership
const providerSignature = await providerWallet.signMessage(
  ethers.utils.arrayify(demographicHash)
);

const createIdentityTx = await identityContract.createProviderIdentity(
  providerWallet.address,
  ethers.utils.formatBytes32String(providerNPI),
  providerSpecialty,
  demographicHash,
  providerSignature
);

const identityReceipt = await createIdentityTx.wait();
const identityEvent = identityReceipt.events.find(e => e.event === 'ProviderIdentityCreated');
const providerDID = identityEvent.args.providerDID;

// 2. Verify medical education
const medicalSchool = await getMedicalSchoolSigner(); // Get signer for medical school authority
const degreeHash = ethers.utils.id(JSON.stringify({
  degree: "Doctor of Medicine",
  institution: "Harvard Medical School",
  graduationDate: "2006-05-15"
}));

const schoolSignature = await medicalSchool.signMessage(
  ethers.utils.arrayify(degreeHash)
);

await educationContract.verifyEducation(
  providerDID,
  await medicalSchool.getAddress(),
  "MD",
  "Medicine",
  new Date("2006-05-15").getTime() / 1000,
  degreeHash,
  schoolSignature
);

// 3. Register medical license
const medicalBoard = await getMedicalBoardSigner(); // Get signer for state medical board
const licenseHash = ethers.utils.id(JSON.stringify({
  licenseNumber: "MD123456",
  state: "Massachusetts",
  issueDate: "2007-07-01"
}));

const boardSignature = await medicalBoard.signMessage(
  ethers.utils.arrayify(licenseHash)
);

await licenseContract.registerLicense(
  providerDID,
  "medical",
  "MD123456",
  "Massachusetts Medical Board",
  new Date("2007-07-01").getTime() / 1000,
  new Date("2025-06-30").getTime() / 1000,
  licenseHash,
  boardSignature
);

// 4. Grant hospital privileges
const hospitalCredentialing = await getHospitalSigner(); // Get hospital credentialing committee signer
const privilegeEvidenceHash = ethers.utils.id(JSON.stringify({
  procedureLogs: "cardiacCatheterization_150cases",
  trainingCertificates: "advancedCardiacLifeSupport"
}));

const hospitalSignature = await hospitalCredentialing.signMessage(
  ethers.utils.arrayify(privilegeEvidenceHash)
);

await privilegingContract.grantPrivilege(
  providerDID,
  await hospitalCredentialing.getAddress(),
  ethers.utils.formatBytes32String("33533"), // CPT code for coronary artery intervention
  2, // Level 2 privileges (full, unsupervised)
  Math.floor(Date.now() / 1000), // Effective immediately
  Math.floor(Date.now() / 1000) + (2 * 365 * 24 * 60 * 60), // Valid for 2 years
  [privilegeEvidenceHash],
  hospitalSignature
);

// 5. Submit peer review
const reviewerWallet = ethers.Wallet.createRandom();
const reviewHash = ethers.utils.id(JSON.stringify({
  clinicalJudgment: 5,
  technicalSkill: 5,
  professionalism: 5,
  communicationSkills: 4,
  overallAssessment: "Outstanding cardiologist with excellent outcomes."
}));

// Encrypt the review for confidentiality
const encryptedReviewHash = await encryptReview(reviewHash, providerDID);

const reviewerSignature = await reviewerWallet.signMessage(
  ethers.utils.arrayify(encryptedReviewHash)
);

await peerReviewContract.connect(reviewerWallet).submitPeerReview(
  reviewerWallet.address, // Reviewer
  providerDID, // Subject of review
  ethers.utils.formatBytes32String("ANNUAL_CLINICAL"), // Review type
  encryptedReviewHash,
  Math.floor(Date.now() / 1000),
  [ethers.utils.formatBytes32String("CASE123"), ethers.utils.formatBytes32String("CASE456")],
  reviewerSignature
);

// 6. Verify provider credentials (for hospital privileging decision)
const verificationResult = await privilegingContract.verifyProviderCredentials(
  providerDID,
  ethers.utils.formatBytes32String("33533"), // Procedure code to verify
  await hospitalCredentialing.getAddress() // Requesting facility
);

console.log("Provider verification:", 
  verificationResult.isVerified ? "Approved" : "Not approved",
  "Education verified:", verificationResult.educationVerified,
  "License active:", verificationResult.licenseActive,
  "Peer reviews satisfactory:", verificationResult.peerReviewSatisfactory
);
```

### API Integration Example

```javascript
// Example API call to verify provider credentials
async function verifyProviderForAppointment(providerDID, procedureCode) {
  try {
    const response = await fetch('https://api.medcred.io/v1/verify-provider', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`
      },
      body: JSON.stringify({
        providerDID,
        procedureCode,
        facilityDID: hospitalDID
      })
    });
    
    const verification = await response.json();
    
    if (verification.verified) {
      console.log('Provider fully credentialed for this procedure');
      scheduleAppointment(patientId, providerDID, procedureCode);
    } else {
      console.log('Provider not credentialed for this procedure');
      console.log('Missing credentials:', verification.missingCredentials);
      notifyCredentialingDepartment(providerDID, verification.missingCredentials);
    }
  } catch (error) {
    console.error('Verification error:', error);
  }
}
```

## Healthcare System Integration

MedCred provides multiple integration options for healthcare organizations:

### Electronic Health Record (EHR) Integration
```javascript
// Example EHR integration for physician lookup
async function findQualifiedPhysicians(specialtyCode, procedureCode, location) {
  const response = await fetch('https://api.medcred.io/v1/qualified-providers', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${apiKey}`
    },
    body: JSON.stringify({
      specialty: specialtyCode,
      procedure: procedureCode,
      location: location,
      radius: 25, // miles
      availability: 'next7days'
    })
  });
  
  const physicians = await response.json();
  
  // Format for EHR physician directory
  return physicians.map(p => ({
    npi: p.nationalProviderIdentifier,
    name: p.name,
    specialty: p.specialty,
    privileged: p.qualifiedForProcedure,
    boardCertified: p.boardCertifications,
    location: p.practiceLocations,
    nextAvailable: p.nextAvailableAppointment
  }));
}
```

### Hospital Credentialing System Integration
Streamlined integration with existing hospital credentialing software:

```javascript
// Example FHIR-based integration
const fhirPractitioner = {
  resourceType: "Practitioner",
  id: providerDID.slice(2), // Remove 0x prefix
  identifier: [
    {
      system: "http://hl7.org/fhir/sid/us-npi",
      value: providerNPI
    }
  ],
  name: [{
    family: providerData.name.family,
    given: providerData.name.given
  }],
  qualification: [
    {
      code: {
        coding: [{
          system: "http://terminology.hl7.org/CodeSystem/v2-0360/2.7",
          code: "MD",
          display: "Doctor of Medicine"
        }]
      },
      issuer: {
        reference: `Organization/${medicalSchoolID}`
      },
      period: {
        start: "2006-05-15"
      }
    }
  ],
  extension: [
    {
      url: "http://medcred.io/fhir/StructureDefinition/blockchain-verification",
      extension: [
        {
          url: "status",
          valueCode: "verified"
        },
        {
          url: "timestamp",
          valueDateTime: new Date().toISOString()
        },
        {
          url: "verificationHash",
          valueString: verificationProof
        }
      ]
    }
  ]
};

// Post to hospital FHIR server
const response = await fetch('https://fhir.hospital.org/Practitioner', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/fhir+json',
    'Authorization': `Bearer ${hospitalApiKey}`
  },
  body: JSON.stringify(fhirPractitioner)
});
```

### Insurance Provider Network Integration
Simplified payer credentialing and network maintenance:

```javascript
// Example integration with payer provider network API
async function updateProviderNetworkStatus() {
  const changedProviders = await medcredClient.getCredentialChanges({
    since: lastSyncTimestamp,
    types: ['license', 'boardCertification', 'sanctions']
  });
  
  for (const provider of changedProviders) {
    if (provider.changes.sanctions && provider.changes.sanctions.added) {
      // Remove from network due to sanctions
      await payerApi.updateProviderStatus(provider.npi, 'suspended', {
        reason: 'credentialIssue',
        detail: 'regulatory sanction',
        effectiveDate: new Date().toISOString()
      });
      
      // Notify network management
      await notificationSystem.alert('provider.network.issue', {
        provider: provider.npi,
        issue: 'New sanction recorded',
        urgency: 'high'
      });
    }
    
    if (provider.changes.license && provider.changes.license.expired) {
      // Flag for network review
      await payerApi.updateProviderStatus(provider.npi, 'review', {
        reason: 'expiredLicense',
        detail: `License ${provider.changes.license.number} expired on ${provider.changes.license.expirationDate}`,
        effectiveDate: new Date().toISOString()
      });
    }
  }
  
  lastSyncTimestamp = new Date().toISOString();
}
```

## Admin Dashboard

MedCred includes a comprehensive administrative interface:

### Credentialing Staff Portal
- Application tracking for new providers
- Documentation verification workflows
- Expiration monitoring and renewal management
- Committee review coordination
- Automated primary source verification

### Provider Self-Service Portal
- Credential submission and updates
- License renewal tracking
- Privileging request management
- Continuing education recording
- Cross-organizational credential sharing

### Analytics and Reporting
- Credentialing process metrics
- Provider qualification analytics
- Regulatory compliance reporting
- Quality and peer review insights
- Network adequacy analysis

## Industry Applications

MedCred is designed for versatility across healthcare sectors:

### Hospitals and Health Systems
- Streamlined provider onboarding
- Reduced credentialing administrative costs
- Enhanced compliance with accreditation standards
- Improved privileging decision support
- Optimized temporary and emergency privileging

### Telemedicine Platforms
- Rapid cross-state license verification
- Streamlined multi-state credentialing
- Real-time provider qualification validation
- Enhanced patient trust in virtual providers
- Simplified privileging across virtual care networks

### Payer Networks
- Automated network provider validation
- Enhanced network directory accuracy
- Streamlined credentialing for value-based contracts
- Rapid identification of licensure issues
- Improved provider onboarding experience

### Locum Tenens Agencies
- Accelerated temporary provider placement
- Portable credential verification
- Multi-facility privileging management
- Streamlined cross-state license validation
- Enhanced temporary provider quality assurance

## Regulatory Compliance

MedCred is designed to meet or exceed healthcare credentialing requirements:

- The Joint Commission (TJC) standards for credentialing
- National Committee for Quality Assurance (NCQA) credentialing standards
- Centers for Medicare & Medicaid Services (CMS) provider enrollment requirements
- State medical board licensure verification standards
- Federation of State Medical Boards (FSMB) guidelines
- HIPAA compliance for sensitive provider information
- DNV GL Healthcare accreditation standards

## Development Roadmap

| Quarter | Milestone |
|---------|-----------|
| Q3 2025 | Core contract deployment and pilot with academic medical centers |
| Q4 2025 | Multi-state license verification network |
| Q1 2026 | Payer network integration framework |
| Q2 2026 | International medical graduate verification system |
| Q3 2026 | Advanced analytics and AI-powered credential risk scoring |
| Q4 2026 | Cross-organizational privileging federation |

## Contributing

We welcome contributions from healthcare technology professionals. Please see our [CONTRIBUTING.md](./CONTRIBUTING.md) for development guidelines.

## License

MedCred is available under a dual licensing model:
- Open source core components under Apache 2.0 License
- Enterprise features under a commercial license

See [LICENSE.md](./LICENSE.md) for details.

## Contact and Support

- Website: [https://medcred.io](https://medcred.io)
- Documentation: [https://docs.medcred.io](https://docs.medcred.io)
- Support: support@medcred.io
- Healthcare partnerships: partnerships@medcred.io
- Twitter: [@MedCredNetwork](https://twitter.com/MedCredNetwork)

---

© 2025 MedCred Foundation. All Rights Reserved.
