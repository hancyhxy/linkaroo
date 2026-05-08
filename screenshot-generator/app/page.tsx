"use client";

import { useEffect, useState, useCallback } from "react";
import { toPng } from "html-to-image";

// ── Constants ──────────────────────────────────────────────
// AussieBridge brand pair (calibrated for the logo, see docs/branding/logo.svg).
// abPrimary (#003955) is the design-system primary, but the logo's deep navy
// (#0C2C5C) and sky-cyan (#22D3EE) are tighter together visually — we use them
// here so the banner reads as the logo's natural extension.
const BRAND_DEEP = "#0C2C5C"; // azure-navy from logo — top accent bar
// Italic headline emphasis ("for you"). We tried two extremes first:
//  - #22D3EE (logo cyan):    too light, ~3:1 contrast on the warm bg, unreadable
//  - #0C2C5C (logo navy):    plenty of contrast, but visually too dark for an
//                            "accent" color — failed to feel "bright blue"
// #005177 is abPrimaryBright from the design system: a mid-tone Pacific blue
// that reads as bright/lively while clearing 7:1 contrast on the warm bg.
const BRAND_ACCENT = "#005177";
// Warm-white gradient lifted from iSpent — gives the banner visual temperature
// instead of looking like an unrendered white card. The brand-cyan italic and
// the deep-navy accent bar still pop against this warm base.
const BG_WARM = "linear-gradient(180deg, #F5F0EB 0%, #E8DFD5 100%)";
const TEXT_DARK = "#181C1D"; // abOnSurface
const TEXT_MUTED = "#41484E"; // abOnSurfaceVariant

const FONT_SERIF = "var(--font-dm-serif), 'DM Serif Display', Georgia, serif";
const FONT_SANS = "var(--font-inter), Inter, system-ui, sans-serif";

// Mockup phone-frame geometry — calibrated against the iSpent mockup.png; same
// asset, so same numbers.
const SCREEN_LEFT = 0.051;
const SCREEN_TOP = 0.022;
const SCREEN_W = 0.898;
const SCREEN_H = 0.956;
const SCREEN_RADIUS = 126;

const IMAGE_PATHS = [
  "/mockup.png",
  "/logo.svg",
  "/screenshots/02-home.png",
];

// ── Image preload cache (data URIs) ───────────────────────
// html-to-image needs images already inlined as data URIs at the moment of
// rendering, so we eagerly fetch + base64 every asset before showing the page.
const imageCache: Record<string, string> = {};

async function preloadImage(path: string): Promise<void> {
  if (imageCache[path]) return;
  const res = await fetch(path);
  const blob = await res.blob();
  return new Promise((resolve) => {
    const reader = new FileReader();
    reader.onloadend = () => {
      imageCache[path] = reader.result as string;
      resolve();
    };
    reader.readAsDataURL(blob);
  });
}

function img(path: string): string {
  return imageCache[path] || path;
}

// ── Phone Component ───────────────────────────────────────
// Generic mockup-frame wrapper — places a screenshot inside the iPhone frame
// at the calibrated screen window.
function Phone({
  screenshot,
  width,
  style,
}: {
  screenshot: string;
  width: number;
  style?: React.CSSProperties;
}) {
  const height = (width / 1022) * 2082;
  return (
    <div
      style={{
        position: "relative",
        width,
        height,
        flexShrink: 0,
        ...style,
      }}
    >
      <img
        src={img("/mockup.png")}
        alt=""
        style={{ width: "100%", height: "100%", position: "absolute", top: 0, left: 0, zIndex: 0 }}
      />
      <img
        src={img(screenshot)}
        alt=""
        style={{
          position: "absolute",
          left: `${SCREEN_LEFT * 100}%`,
          top: `${SCREEN_TOP * 100}%`,
          width: `${SCREEN_W * 100}%`,
          height: `${SCREEN_H * 100}%`,
          borderRadius: (SCREEN_RADIUS * width) / 1022,
          objectFit: "cover",
          zIndex: 1,
        }}
      />
    </div>
  );
}

// ── Banner Slide (horizontal, for GitHub README) ─────────
const BANNER_W = 2560;
const BANNER_H = 860;

function BannerSlide({ id }: { id: string }) {
  // Phone scaled by banner *width*. 0.22 is the sweet spot found by iteration:
  // small enough that the home-page Essential Services grid (~22%-44% of the
  // screen height) is fully visible AND the right-side text column has room
  // to breathe; large enough that the service icons still read clearly.
  const phoneW = BANNER_W * 0.22;
  const phoneH = (phoneW / 1022) * 2082;
  const tags = ["Onboarding", "Community", "Q&A", "Volunteer Match", "Messages"];
  const contentW = BANNER_W * 0.78;
  // Single y-anchor for the right-side text column: logo + name start here,
  // and the phone is positioned so its inner *screen* (not the bezel) starts
  // on the same y-line — mockup.png reserves SCREEN_TOP (2.2%) for the top
  // bezel, so we offset the phone upward by that amount. Some of the bezel
  // ends up clipped above banner top, which is what we want.
  const TOP_OFFSET = BANNER_H * 0.14;
  const PHONE_TOP = TOP_OFFSET - phoneH * SCREEN_TOP;
  return (
    <div
      id={id}
      style={{
        width: BANNER_W,
        height: BANNER_H,
        background: BG_WARM,
        display: "flex",
        justifyContent: "center",
        overflow: "hidden",
        position: "relative",
      }}
    >
      {/* Top accent bar — deep navy from the logo, signals brand without crowding text */}
      <div
        style={{
          position: "absolute",
          top: 0,
          left: 0,
          width: "100%",
          height: BANNER_H * 0.012,
          background: BRAND_DEEP,
          zIndex: 10,
        }}
      />
      {/* Centered inner wrapper */}
      <div
        style={{
          width: contentW,
          height: "100%",
          display: "flex",
          position: "relative",
        }}
      >
        {/* Left: phone — positioned so the SCREEN (not the bezel) top aligns
            with the logo row. Top bezel clips above banner edge. */}
        <Phone
          screenshot="/screenshots/02-home.png"
          width={phoneW}
          style={{
            flexShrink: 0,
            alignSelf: "flex-start",
            marginTop: PHONE_TOP,
          }}
        />

        {/* Right: text content — top-aligned to TOP_OFFSET so the logo row
            starts on the same y-line as the phone's top edge */}
        <div
          style={{
            flex: 1,
            paddingLeft: BANNER_W * 0.03,
            display: "flex",
            flexDirection: "column",
            justifyContent: "flex-start",
            position: "absolute",
            top: TOP_OFFSET,
            bottom: 0,
            left: phoneW,
            right: 0,
            gap: BANNER_H * 0.03,
          }}
        >
          {/* Logo + App name. Logo SVG is square (1024x1024) with its own
              opaque background; no rounded clip needed. */}
          <div style={{ display: "flex", alignItems: "center", gap: BANNER_W * 0.008 }}>
            <img
              src={img("/logo.svg")}
              alt=""
              style={{ width: BANNER_H * 0.12, height: BANNER_H * 0.12, borderRadius: BANNER_H * 0.025 }}
            />
            <span
              style={{
                fontFamily: FONT_SANS,
                fontSize: BANNER_H * 0.06,
                fontWeight: 600,
                color: TEXT_MUTED,
                letterSpacing: "0.01em",
              }}
            >
              AussieBridge
            </span>
          </div>

          {/* Headline — two lines: ask, then answer. Italic + cyan on the
              promise so the eye lands there. */}
          <div
            style={{
              fontFamily: FONT_SERIF,
              fontSize: BANNER_H * 0.17,
              fontWeight: 400,
              color: TEXT_DARK,
              lineHeight: 1.05,
            }}
          >
            Newcomer?
            <br />
            Made <span style={{ color: BRAND_ACCENT, fontStyle: "italic" }}>for you.</span>
          </div>

          {/* Subtitle — the mechanism in one breath */}
          <div
            style={{
              fontFamily: FONT_SANS,
              fontSize: BANNER_H * 0.04,
              fontWeight: 400,
              color: TEXT_MUTED,
              lineHeight: 1.4,
            }}
          >
            A context-first app where identity, location, and urgency act as a filter — not a feature.
          </div>

          {/* Tags */}
          <div
            style={{
              display: "flex",
              flexWrap: "wrap",
              gap: BANNER_H * 0.022,
              marginTop: BANNER_H * 0.01,
            }}
          >
            {tags.map((tag) => (
              <div
                key={tag}
                style={{
                  fontFamily: FONT_SANS,
                  fontSize: BANNER_H * 0.035,
                  fontWeight: 500,
                  color: TEXT_DARK,
                  padding: `${BANNER_H * 0.015}px ${BANNER_H * 0.035}px`,
                  border: `1.5px solid ${TEXT_MUTED}40`,
                  borderRadius: BANNER_H * 0.06,
                  background: "rgba(255,255,255,0.5)",
                }}
              >
                {tag}
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

// ── Main Page ─────────────────────────────────────────────
export default function Page() {
  const [loaded, setLoaded] = useState(false);
  const [exporting, setExporting] = useState(false);
  const [exportStatus, setExportStatus] = useState("");

  useEffect(() => {
    Promise.all(IMAGE_PATHS.map(preloadImage)).then(() => setLoaded(true));
  }, []);

  const exportSlide = useCallback(async (elId: string, w: number, h: number, filename: string) => {
    const el = document.getElementById(elId);
    if (!el) return;
    // First call warms the html-to-image internal font/image cache; the second
    // call produces the canonical PNG (otherwise large fonts can render at
    // pre-load metrics).
    await toPng(el, { width: w, height: h, pixelRatio: 1 });
    await new Promise((r) => setTimeout(r, 300));
    const dataUrl = await toPng(el, { width: w, height: h, pixelRatio: 1 });
    const link = document.createElement("a");
    link.download = filename;
    link.href = dataUrl;
    link.click();
    await new Promise((r) => setTimeout(r, 300));
  }, []);

  const exportBanner = useCallback(async () => {
    setExporting(true);
    setExportStatus("Exporting banner...");
    await exportSlide("slide-banner", BANNER_W, BANNER_H, "00-banner.png");
    setExportStatus("Done!");
    setExporting(false);
  }, [exportSlide]);

  if (!loaded) {
    return (
      <div className="flex items-center justify-center min-h-screen bg-gray-100">
        <p className="text-lg text-gray-600">Loading images...</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-100 p-8">
      <div className="flex items-center gap-4 mb-8">
        <h1 className="text-2xl font-bold">AussieBridge Banner Generator</h1>
        <button
          onClick={exportBanner}
          disabled={exporting}
          className="px-6 py-2 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700 disabled:opacity-50"
        >
          {exporting ? exportStatus : "Export 00-banner.png"}
        </button>
      </div>

      {/* Banner preview */}
      <div className="mb-8">
        <div className="flex flex-col items-start gap-2">
          <div
            style={{
              width: 960,
              height: (BANNER_H / BANNER_W) * 960,
              overflow: "hidden",
              borderRadius: 12,
              boxShadow: "0 4px 20px rgba(0,0,0,0.15)",
            }}
          >
            <div style={{ transform: `scale(${960 / BANNER_W})`, transformOrigin: "top left" }}>
              <BannerSlide id="slide-banner" />
            </div>
          </div>
          <span className="text-sm text-gray-500 font-medium">00-banner</span>
        </div>
      </div>
    </div>
  );
}
