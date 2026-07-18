---
layout: default
title: Contact
permalink: /contact/
description: Get in touch with Akshay Bhalotia — email or find me on any of these.
---
<section>
  <h1 class="font-head text-2xl xs:text-3xl desk:text-[2.5rem] font-bold leading-snug break-words">Get in touch</h1>

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
     class="app-social-link mt-10 inline-flex items-center gap-3 bg-card text-card-ink rounded-card shadow-card px-6 py-4 font-bold text-lg hover:opacity-80 transition-opacity break-all">
    <svg class="w-6 h-6 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <rect x="2" y="4" width="20" height="16" rx="2"/>
      <path d="m2 7 10 6 10-6"/>
    </svg>
    {{ site.email | obfuscate_email }}
  </a>

  {%- comment -%} Social — same brand-colored circle badges as the sidebar, but
  labelled here. Reuses .app-social-link so they inherit the focus-visible ring,
  and _data/social.yml + icon.html so the set stays in sync with the sidebar. {%- endcomment -%}
  {%- if site.data.social and site.data.social.size > 0 -%}
  <h2 class="font-head mt-16 text-2xl desk:text-3xl font-bold">Find me elsewhere</h2>
  <ul class="mt-6 grid grid-cols-1 xs:grid-cols-2 gap-4">
    {%- for s in site.data.social -%}
    <li>
      <a href="{{ s.url | relative_url }}" target="_blank" rel="noopener"
         class="app-social-link group flex items-center gap-4 rounded-card px-2 py-2 -mx-2 hover:opacity-80 transition-opacity">
        <span class="grid place-items-center size-10 rounded-full shrink-0" style="background-color: {{ s.bg | default: '#ffffff' }}; color: {{ s.fg | default: '#000000' }}">
          {%- include icon.html name=s.icon class="w-5 h-5" -%}
        </span>
        <span class="text-lg font-bold">{{ s.name }}<span class="sr-only"> (opens in a new tab)</span></span>
      </a>
    </li>
    {%- endfor -%}
  </ul>
  {%- endif -%}
</section>
