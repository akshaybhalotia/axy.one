---
layout: default
title: Contact
permalink: /contact/
description: Get in touch with Akshay Bhalotia — email or find me on any of these.
---
<section>
  <h1 class="page-title">Get in touch</h1>

  <div class="rich mt-10 text-lg desk:text-xl leading-relaxed">
    <p>I like getting to know people — personally and professionally. Catch me for a conversation, and let's see how we can help each other!</p>
    <p>The quickest way to reach me is email. I'm also around on most of the usual places.</p>
  </div>

  {%- comment -%} Primary email CTA — light card on the dark panel, mirroring the
  card treatment (bg-card / rounded-card / shadow-card) used elsewhere. The address
  (and the "mailto:" scheme) is entity-encoded via the obfuscate_email filter so it
  never appears as literal text in the page source. {%- endcomment -%}
  <!--
    👋 Reading the source? Respect. The address below is entity-encoded on
    purpose — bots get gibberish, your browser quietly decodes it. If you got
    this far, we'll probably get along. Say hi the hard way.
  -->
  <a href="{{ site.email | prepend: 'mailto:' | obfuscate_email }}"
     class="card app-social-link mt-10 inline-flex items-center gap-3 px-6 py-4 font-bold text-lg hover:opacity-80 transition-opacity break-all">
    {%- include icon.html name="email" class="w-6 h-6 shrink-0" -%}
    {{ site.email | obfuscate_email }}
  </a>

  {%- comment -%} Social — same brand-colored circle badges as the sidebar, but
  labelled here. Reuses .app-social-link so they inherit the focus-visible ring,
  and _data/social.yml + icon.html so the set stays in sync with the sidebar. {%- endcomment -%}
  {%- if site.data.social and site.data.social.size > 0 -%}
  <h2 class="section-title mt-16">Find me elsewhere</h2>
  <ul class="mt-6 grid grid-cols-1 xs:grid-cols-2 gap-4">
    {%- for s in site.data.social -%}
    <li>{%- include social-link.html item=s -%}</li>
    {%- endfor -%}
  </ul>
  {%- endif -%}
</section>
