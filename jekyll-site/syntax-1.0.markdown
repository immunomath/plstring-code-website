---
layout: page
title: PLSC 1.0 Syntax
permalink: /syntax-1.0.html
---

<p style="color:darkgrey;">Draft status:  This content is under review, and may be subject to revision.</p>

## Version 1.0

The Phenotype List String Code (PLSC) code system defines a syntax for using the Phenotype List String (PL String) grammar in association with a gene family namespace.

## PL String Code Syntax    {#syntax}

The PL String Code is composed of three required fields in a string separated by a "#" character.  These fields, in order, are:

* [Gene family namespace](#namespace)
* [Version of the nomenclature, or the date when the PL String was created](#versionordate)
* [PL String](#plstring)

    *__namespace__*`#`*__version_or_date__*`#`*__plstring__*

See below for [examples](#glscexamples).

## Gene family namespace    {#namespace}

Each gene family namespace represents one or more code systems.  When more than one code system is used, a base system is designated which is then extended by the other code systems.

<table style="border: 0px">
  <tbody>
    <tr>
      <td style="border: 0px; vertical-align: middle;" width="36%" markdown="span">![Code Systems Comprising hla Namespace](/assets/images/hla-code-systems.png){:height="230px" width="230px"}</td>
      <td style="border: 0px; vertical-align: middle;" markdown="span">For example, the `hla` namespace supports the IPD-IMGT/HLA allele database as the base system, as well as the National Marrow Donor Program (NMDP) multiple allele code system used to describe allele ambiguity, and the World Marrow Donor Association (WMDA) extensions (“NNNN”, “XXXX”, “UUUU” and “NEW”).</td>
    </tr>
  </tbody>
</table>

### Supported namespaces

<table>
  <thead>
    <tr>
      <th style="text-align: center">Namespace</th>
      <th>Code System</th>
      <th style="text-align: center">Ref</th>
      <th>Version Notes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: center" rowspan="4" markdown="span">`hla`</td>
      <td markdown="span">IPD-IMGT/HLA</td>
      <td style="text-align: center" markdown="span">*a*</td>
      <td markdown="span">tied to IPD-IMGT/HLA release version</td>
    </tr>
    <tr>
      <td markdown="span">NMDP multiple allele code (MAC) designation</td>
      <td style="text-align: center" markdown="span">*b*</td>
      <td markdown="span">versionless, but usage may be tied to IPD-IMGT/HLA release version</td>
    </tr>
    <tr>
      <td markdown="span">WMDA additional codes</td>
      <td style="text-align: center" markdown="span">*c*</td>
      <td markdown="span">versionless, but usage may be tied to IPD-IMGT/HLA release version</td>
    </tr>
    <tr>
      <td markdown="span">XX codes</td>
      <td style="text-align: center" markdown="span">*c*</td>
      <td markdown="span">versionless, but usage may be tied to IPD-IMGT/HLA release version</td>
    </tr>
    <tr>
      <td style="text-align: center" markdown="span">`kir`</td>
      <td markdown="span">IPD-KIR</td>
      <td style="text-align: center" markdown="span">*d*</td>
      <td markdown="span">tied to IPD-KIR release version</td>
    </tr>
  </tbody>
</table>

*a*. [https://www.ebi.ac.uk/ipd/imgt/hla]  
*b*. [https://bioinformatics.bethematchclinical.org/hla-resources/allele-codes/allele-code-lists]  
*c*. [https://doi.org/10.1038/sj.bmt.1705672]  
*d*. [https://www.ebi.ac.uk/ipd/kir]

## Version or date    {#versionordate}

The second field of the PL String Code contains the version of the base nomenclature of the gene family namespace.  When the version is not available, the date when the PL String was constructed is used.  This reflects the most recent version possible of the nomenclature.  This field is not optional.

### Version

When available, the version of the base nomenclature release is preferred over the date. A fully qualified version should be used (e.g., `3.33.0` vs `3.33`).

#### Version examples:

* `3.20.0`
* `3.25.0`

### Date

If using the date, the format must be as described for the HL7 FHIR date type ([https://hl7.org/fhir/datatypes.html#date]). Briefly,

>  *A date, or partial date (e.g. just year or year + month) as used in human communication. There is no time zone. Dates SHALL be valid dates.*  
> *Regex: -?[0-9]{4}(-(0[1-9]|1[0-2])(-(0[0-9]|[1-2][0-9]|3[0-1]))?)?*

#### Date examples:

* `2017-10-15`
* `2015-01`
* `2018`

## Phenotype List String (PL String)    {#plstring}

The PL String format uses a hierarchical set of operators to describe the relationships between alleles, lists of possible alleles, phased alleles, phenotype, lists of possible phenotype, and multilocus unphased phenotype, without losing typing information or increasing typing ambiguity.

The PL String grammar is described in  
*Phenotype List String: a grammar for describing HLA and KIR genotyping results in a text string*
Tissue Antigens. 2013 Aug;82(2):106-12. doi: [10.1111/tan.12150][https://doi.org/10.1111/tan.12150]


### PL String delimiters & precedence

| Precedence | Delimiter | Description |
| :--------: | :-------: | :---------- |
| 1          | `^`       | Gene/Locus<br />*used in multilocus unphased phenotype* |
| 2          | `|`       | Phenotype List<br />*to describe phenotype ambiguity where the typing system cannot distinguish chromosomal phase* |
| 3          | `+`       | Phenotype    |
| 4          | `~`       | Haplotype<br />*used to describe alleles that are in chromosomal phase (cis)* |
| 5          | `/`       | Allele List<br />*to describe allele ambiguity where the typing system cannot distinguish between alleles* |

#### PL String parsing

![PL String Components of a Multilocus Unphased Phenotype (MUG)](/assets/images/gl-string-components.png){:style="border: 1px solid #e8e8e8"}
*Parsing of PL String delimiters in a multilocus unphased phenotype*

#### PL String examples

* HLA-A phenotype with ambiguous allele
   * `HLA-A*01:01:01:01/HLA-A*01:02+HLA-A*24:02:01:01`{: .language-plstring}
* HLA-A ambiguous phenotype
   * `HLA-A*01:02+HLA-A*03:02:01|HLA-A*01:03:01:01+HLA-A*03:04:01`{: .language-plstring}
* HLA-DR haplotype
   * `HLA-DRB1*03:01:02~HLA-DRB5*01:01:01`{: .language-plstring}
* HLA multi-locus unphased phenotype
   * `HLA-A*02:302+HLA-A*23:26/HLA-A*23:39^HLA-B*44:02:13+HLA-B*49:08`{: .language-plstring}
* KIR ambiguous phenotype
   * `KIR3DL2*001+KIR3DL2*007|KIR3DL2*006+KIR3DL2*010`{: .language-plstring}

## PL String Code Examples    {#glscexamples}

#### Base nomenclature only

* `hla#3.25.0#HLA-A*01:01:01:01/HLA-A*01:02+HLA-A*24:02:01:01`{: .language-glsc}
* `hla#3.29.0#HLA-DRB1*03:01:02~HLA-DRB5*01:01:01`{: .language-glsc}
* `hla#3.33.0#HLA-A*02:69+HLA-A*23:30|HLA-A*02:302+HLA-A*23:26/HLA-A*23:39`{: .language-glsc}
* `hla#2018-06#HLA-A*02:69+HLA-A*23:30`{: .language-glsc}
* `kir#2.3#KIR3DL2*001+KIR3DL2*007|KIR3DL2*006+KIR3DL2*010`{: .language-glsc}

#### NMDP Multiple Allele Code (MAC) Designations

* `hla#2018-03-01#HLA-DPB1*04:ANKZX+HLA-DPB1*04:FNVS`{: .language-glsc}

#### MAC and WMDA extensions

* `hla#3.25.0#HLA-DPB1*04:ANKZX+HLA-DPB1*04:FNVS^HLA-DRB3*XXXX`{: .language-glsc}

#### as a valueCodeableConcept.coding within a HL7 FHIR Observation...

~~~ xml
<valueCodeableConcept>
  <coding>
    <system value="http://plstring.org"/>
    <version value="1.0"/>
    <code value="hla#3.25.0#HLA-A*01:01:01:01/HLA-A*01:02+HLA-A*24:02:01:01"/>
  </coding>
</valueCodeableConcept>
~~~

## References & Links    {#references}

TBD "PL string manuscript"
TBD "PL string code manuscript"

[comment]: / "Please keep all reference link definitions below, at bottom of document."
TBD "PL string manuscript"
TBD "PL string code manuscript"
