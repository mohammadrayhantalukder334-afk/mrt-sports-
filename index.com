```html
<!DOCTYPE html>
<html lang="bn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>স্পোর্টস টুর্নামেন্ট নিবন্ধন, খেলোয়াড় ড্যাশবোর্ড ও ভোটিং পোর্টাল</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts: Hind Siliguri & Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Hind+Siliguri:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        body {
            font-family: 'Hind Siliguri', 'Inter', sans-serif;
            background-color: #f1f5f9;
        }
        ::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        ::-webkit-scrollbar-track {
            background: #f1f5f9;
        }
        ::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: #94a3b8;
        }
        @media print {
            body * {
                visibility: hidden;
            }
            #printable-slip, #printable-slip * {
                visibility: visible;
            }
            #printable-slip {
                position: fixed;
                left: 0;
                top: 0;
                width: 100%;
                box-shadow: none !important;
                border: 2px solid #059669 !important;
            }
            .no-print {
                display: none !important;
            }
        }
    </style>
</head>
<body class="text-slate-800 antialiased min-h-screen flex flex-col">

    <!-- Custom Notification Toast -->
    <div id="toast-container" class="fixed top-4 right-4 z-50 flex flex-col gap-2 max-w-sm w-full pointer-events-none px-4 sm:px-0"></div>

    <!-- Header / Hero Banner -->
    <header class="bg-gradient-to-r from-emerald-900 via-emerald-800 to-teal-800 text-white shadow-lg">
        <div class="max-w-6xl mx-auto px-4 py-6 sm:py-8">
            <div class="flex flex-col md:flex-row items-center justify-between gap-4">
                <div class="flex items-center gap-4 text-center md:text-left">
                    <div class="w-14 h-14 sm:w-16 sm:h-16 bg-white/15 backdrop-blur-sm rounded-2xl flex items-center justify-center border border-white/25 shadow-inner shrink-0">
                        <i data-lucide="trophy" class="w-8 h-8 text-amber-300"></i>
                    </div>
                    <div>
                        <span class="inline-block px-2.5 py-0.5 rounded-full text-xs font-semibold bg-amber-400/20 text-amber-200 border border-amber-300/30 mb-1">
                            অনলাইন স্পোর্টস পোর্টাল ২০২৬
                        </span>
                        <h1 class="text-2xl sm:text-3xl font-bold tracking-tight">বার্ষিক ক্রীড়া টুর্নামেন্ট</h1>
                        <p class="text-emerald-100 text-sm sm:text-base">নিবন্ধন, খেলোয়াড় ড্যাশবোর্ড, অনলাইন ভোটিং ও পরিচালনা পরিষদ</p>
                    </div>
                </div>
                <div class="flex items-center gap-2 bg-emerald-950/40 px-4 py-2 rounded-xl border border-white/10 text-sm">
                    <i data-lucide="check-circle-2" class="w-4 h-4 text-emerald-400"></i>
                    <span>নিবন্ধন ও পোর্টাল সক্রিয়</span>
                </div>
            </div>

            <!-- Navigation Tabs -->
            <nav class="mt-6 grid grid-cols-2 lg:grid-cols-4 gap-2 bg-emerald-950/35 p-1.5 rounded-2xl border border-white/10">
                <button onclick="switchTab('register')" id="tab-register" class="tab-btn py-2.5 px-3 rounded-xl font-semibold text-xs sm:text-sm md:text-base flex items-center justify-center gap-2 transition-all bg-white text-emerald-800 shadow-sm">
                    <i data-lucide="user-plus" class="w-4 h-4 shrink-0"></i>
                    <span>নিবন্ধন ফর্ম</span>
                </button>
                <button onclick="switchTab('player')" id="tab-player" class="tab-btn py-2.5 px-3 rounded-xl font-semibold text-xs sm:text-sm md:text-base flex items-center justify-center gap-2 transition-all text-emerald-100 hover:bg-white/10">
                    <i data-lucide="layout-dashboard" class="w-4 h-4 shrink-0"></i>
                    <span>খেলোয়াড় ড্যাশবোর্ড</span>
                </button>
                <button onclick="switchTab('voting')" id="tab-voting" class="tab-btn py-2.5 px-3 rounded-xl font-semibold text-xs sm:text-sm md:text-base flex items-center justify-center gap-2 transition-all text-emerald-100 hover:bg-white/10">
                    <i data-lucide="vote" class="w-4 h-4 shrink-0"></i>
                    <span>অনলাইন ভোটিং</span>
                </button>
                <button onclick="switchTab('admin')" id="tab-admin" class="tab-btn py-2.5 px-3 rounded-xl font-semibold text-xs sm:text-sm md:text-base flex items-center justify-center gap-2 transition-all text-emerald-100 hover:bg-white/10">
                    <i data-lucide="shield-check" class="w-4 h-4 shrink-0"></i>
                    <span>পরিচালনা পরিষদ</span>
                </button>
            </nav>
        </div>
    </header>

    <!-- Main Content Area -->
    <main class="flex-grow max-w-6xl w-full mx-auto px-4 py-6 sm:py-8">

        <!-- ==========================================
             TAB 1: PLAYER REGISTRATION FORM
        =========================================== -->
        <section id="section-register" class="tab-section">
            <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
                <div class="bg-slate-50 border-b border-slate-200 px-6 py-4 flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                    <div>
                        <h2 class="text-xl font-bold text-slate-800">খেলোয়াড় নিবন্ধন ফর্ম</h2>
                        <p class="text-sm text-slate-500">সঠিক তথ্য দিয়ে নিচের ফর্মটি পূরণ করুন (<span class="text-red-500">*</span> চিহ্নিত ঘরগুলো বাধ্যতামূলক)</p>
                    </div>
                    <span class="text-xs font-semibold px-3 py-1 bg-emerald-100 text-emerald-700 rounded-full w-fit">
                        রেজিস্ট্রেশন ফি: ৩০০ টাকা
                    </span>
                </div>

                <form id="registration-form" class="p-6 space-y-8">
                    <!-- 1. Photo & Personal Info -->
                    <div>
                        <h3 class="text-lg font-bold text-emerald-800 border-b border-emerald-100 pb-2 mb-4 flex items-center gap-2">
                            <span class="w-7 h-7 rounded-lg bg-emerald-100 text-emerald-700 flex items-center justify-center text-sm">১</span>
                            ব্যক্তিগত তথ্য ও ছবি
                        </h3>

                        <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
                            <!-- Photo Upload Box -->
                            <div class="lg:col-span-1 flex flex-col items-center justify-center bg-slate-50 border-2 border-dashed border-slate-300 rounded-2xl p-4 text-center hover:border-emerald-500 transition-colors">
                                <div class="w-32 h-36 rounded-xl bg-slate-200 overflow-hidden mb-3 border border-slate-300 flex items-center justify-center relative shadow-inner">
                                    <img id="photo-preview" src="https://placehold.co/300x350/e2e8f0/64748b?text=ছবি+দিন" alt="Player Preview" class="w-full h-full object-cover">
                                </div>
                                <label for="player-photo" class="cursor-pointer bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-semibold px-4 py-2 rounded-xl transition shadow-sm flex items-center gap-1.5">
                                    <i data-lucide="camera" class="w-4 h-4"></i>
                                    <span>ছবি নির্বাচন করুন</span>
                                </label>
                                <input type="file" id="player-photo" accept="image/*" class="hidden" onchange="previewImage(event)">
                                <p class="text-[11px] text-slate-400 mt-2">পাসপোর্ট সাইজ ছবি (সর্বোচ্চ ২ MB)</p>
                            </div>

                            <!-- Personal Fields -->
                            <div class="lg:col-span-3 grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-1">খেলোয়াড়ের পূর্ণ নাম <span class="text-red-500">*</span></label>
                                    <input type="text" id="fullName" required placeholder="যেমন: মোঃ তানভীর আহমেদ" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition">
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-1">মোবাইল নম্বর (WhatsApp) <span class="text-red-500">*</span></label>
                                    <input type="tel" id="mobile" required placeholder="017XXXXXXXX" pattern="[0-9]{11}" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition">
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-1">পিতার নাম <span class="text-red-500">*</span></label>
                                    <input type="text" id="fatherName" required placeholder="পিতার পূর্ণ নাম লিখুন" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition">
                                </div>
                                <div>
                                    <label class="block text-sm font-semibold text-slate-700 mb-1">মাতার নাম <span class="text-red-500">*</span></label>
                                    <input type="text" id="motherName" required placeholder="মাতার পূর্ণ নাম লিখুন" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition">
                                </div>
                                <div class="sm:col-span-2">
                                    <label class="block text-sm font-semibold text-slate-700 mb-1">জাতীয় পরিচয়পত্র (NID) / জন্ম নিবন্ধন নম্বর <span class="text-red-500">*</span></label>
                                    <input type="text" id="nidNumber" required placeholder="১০, ১৩ বা ১৭ ডিজিটের এনআইডি অথবা জন্ম নিবন্ধন নম্বর" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 2. Address Details -->
                    <div>
                        <h3 class="text-lg font-bold text-emerald-800 border-b border-emerald-100 pb-2 mb-4 flex items-center gap-2">
                            <span class="w-7 h-7 rounded-lg bg-emerald-100 text-emerald-700 flex items-center justify-center text-sm">২</span>
                            স্থায়ী ও বর্তমান ঠিকানা
                        </h3>
                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1">জেলা (District) <span class="text-red-500">*</span></label>
                                <input type="text" id="district" required placeholder="যেমন: কুমিল্লা / ঢাকা / বগুড়া" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1">উপজেলা / থানা (Upazila) <span class="text-red-500">*</span></label>
                                <input type="text" id="upazila" required placeholder="উপজেলার নাম লিখুন" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1">ইউনিয়ন / পৌরসভা (Union) <span class="text-red-500">*</span></label>
                                <input type="text" id="unionName" required placeholder="ইউনিয়ন বা পৌরসভার নাম" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1">গ্রাম (Village) <span class="text-red-500">*</span></label>
                                <input type="text" id="village" required placeholder="গ্রামের নাম লিখুন" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition">
                            </div>
                            <div class="sm:col-span-2">
                                <label class="block text-sm font-semibold text-slate-700 mb-1">পাড়া / মহল্লা (Para / Mahalla) <span class="text-red-500">*</span></label>
                                <input type="text" id="para" required placeholder="পাড়া বা মহল্লার নাম লিখুন" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition">
                            </div>
                        </div>
                    </div>

                    <!-- 3. Player Profile & Details -->
                    <div>
                        <h3 class="text-lg font-bold text-emerald-800 border-b border-emerald-100 pb-2 mb-4 flex items-center gap-2">
                            <span class="w-7 h-7 rounded-lg bg-emerald-100 text-emerald-700 flex items-center justify-center text-sm">৩</span>
                            খেলোয়াড় বিবরণী
                        </h3>
                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1">খেলার ধরন <span class="text-red-500">*</span></label>
                                <select id="sportType" onchange="updateRoles()" required class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none bg-white">
                                    <option value="ক্রিকেট">ক্রিকেট (Cricket)</option>
                                    <option value="ফুটবল">ফুটবল (Football)</option>
                                    <option value="ব্যাডমিন্টন">ব্যাডমিন্টন (Badminton)</option>
                                    <option value="ভলিবল">ভলিবল (Volleyball)</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1">খেলোয়াড়ের পজিশন / ভূমিকা <span class="text-red-500">*</span></label>
                                <select id="playingRole" required class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none bg-white">
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1">জার্সি সাইজ <span class="text-red-500">*</span></label>
                                <select id="jerseySize" required class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none bg-white">
                                    <option value="S">S (Small)</option>
                                    <option value="M">M (Medium)</option>
                                    <option value="L" selected>L (Large)</option>
                                    <option value="XL">XL (Extra Large)</option>
                                    <option value="XXL">XXL</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1">পছন্দের জার্সি নম্বর</label>
                                <input type="number" id="jerseyNumber" min="0" max="999" placeholder="যেমন: ১০ বা ৭৫" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition">
                            </div>
                            <div class="sm:col-span-2 lg:col-span-4">
                                <label class="block text-sm font-semibold text-slate-700 mb-1">পূর্ববর্তী ক্লাব / খেলার অভিজ্ঞতা (যদি থাকে)</label>
                                <input type="text" id="experience" placeholder="যেমন: ইউনিয়ন পর্যায়ে ৩ বছর খেলার অভিজ্ঞতা / সবুজ সংঘ ক্লাব" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition">
                            </div>
                        </div>
                    </div>

                    <!-- 4. Payment Gateway Info -->
                    <div class="bg-amber-50/70 border border-amber-200 rounded-2xl p-5">
                        <h3 class="text-lg font-bold text-amber-900 border-b border-amber-200 pb-2 mb-3 flex items-center gap-2">
                            <span class="w-7 h-7 rounded-lg bg-amber-200 text-amber-900 flex items-center justify-center text-sm">৪</span>
                            পেমেন্ট গেটওয়ে ও ট্রানজেকশন তথ্য
                        </h3>
                        <div class="bg-white p-3.5 rounded-xl border border-amber-200/80 mb-4 text-sm text-slate-700 flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                            <div>
                                <span class="font-semibold text-amber-800">নির্দেশনা:</span> নিচের মার্চেন্ট/পার্সোনাল নম্বরে <strong>৩০০ টাকা</strong> Send Money বা Payment করে ট্রানজেকশন আইডি দিন।
                            </div>
                            <div class="flex flex-wrap gap-2 font-mono text-xs font-bold">
                                <span class="px-2.5 py-1 rounded-lg bg-pink-100 text-pink-700">bKash: 01700-000000</span>
                                <span class="px-2.5 py-1 rounded-lg bg-orange-100 text-orange-700">Nagad: 01800-000000</span>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1">পেমেন্ট মাধ্যম <span class="text-red-500">*</span></label>
                                <select id="paymentMethod" required class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none bg-white">
                                    <option value="বিকাশ (bKash)">বিকাশ (bKash)</option>
                                    <option value="নগদ (Nagad)">নগদ (Nagad)</option>
                                    <option value="রকেট (Rocket)">রকেট (Rocket)</option>
                                    <option value="হাতে হাতে (Cash)">সরাসরি / হাতে হাতে</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1">প্রেরক মোবাইল নম্বর <span class="text-red-500">*</span></label>
                                <input type="tel" id="senderNumber" required placeholder="যে নম্বর থেকে টাকা পাঠিয়েছেন" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none bg-white">
                            </div>
                            <div>
                                <label class="block text-sm font-semibold text-slate-700 mb-1">ট্রানজেকশন আইডি (TrxID) <span class="text-red-500">*</span></label>
                                <input type="text" id="trxId" required placeholder="যেমন: 9H7G6F5D4S" class="w-full px-4 py-2.5 rounded-xl border border-slate-300 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none bg-white font-mono uppercase">
                            </div>
                        </div>
                    </div>

                    <!-- 5. Declaration Box -->
                    <div class="bg-emerald-50/60 border-2 border-emerald-200 rounded-2xl p-5 shadow-inner">
                        <h3 class="text-base sm:text-lg font-bold text-emerald-900 border-b border-emerald-200 pb-2 mb-3 flex items-center gap-2">
                            <i data-lucide="file-signature" class="w-5 h-5 text-emerald-700"></i>
                            <span>অঙ্গীকারনামা (Declaration)</span>
                        </h3>
                        <p class="text-sm text-slate-700 leading-relaxed mb-4 text-justify">
                            আমি এই মর্মে অঙ্গীকার করছি যে, উপরে প্রদত্ত আমার ব্যক্তিগত তথ্য, ঠিকানা, জাতীয় পরিচয়পত্র নম্বর এবং পেমেন্ট সংক্রান্ত সকল তথ্য সম্পূর্ণ সত্য ও নির্ভুল। টুর্নামেন্ট চলাকালীন আমি টুর্নামেন্ট পরিচালনা পরিষদের সকল নিয়ম-কানুন, শৃঙ্খলা এবং রেফারি/আম্পায়ারের সিদ্ধান্ত চূড়ান্ত বলে মেনে নিতে বাধ্য থাকব। কোনো তথ্য মিথ্যা বা বানোয়াট প্রমাণিত হলে পরিচালনা পরিষদ আমার নিবন্ধন বাতিল করার পূর্ণ অধিকার সংরক্ষণ করে।
                        </p>
                        <label class="flex items-start sm:items-center gap-3 cursor-pointer bg-white p-3.5 rounded-xl border border-emerald-300 hover:bg-emerald-50/40 transition select-none">
                            <input type="checkbox" id="declarationCheck" required class="mt-0.5 sm:mt-0 w-5 h-5 text-emerald-600 rounded border-slate-300 focus:ring-emerald-500 cursor-pointer shrink-0">
                            <span class="text-sm font-semibold text-slate-800">
                                আমি উপরের অঙ্গীকারনামার সকল শর্তাবলি পড়েছি এবং সম্পূর্ণরূপে একমত হয়ে আবেদন করছি। <span class="text-red-500">*</span>
                            </span>
                        </label>
                    </div>

                    <!-- Submit Button -->
                    <div class="pt-2 flex flex-col sm:flex-row items-center justify-between gap-4 border-t border-slate-100">
                        <p class="text-xs text-slate-500 flex items-center gap-1.5">
                            <i data-lucide="shield-check" class="w-4 h-4 text-emerald-600"></i>
                            <span>নিবন্ধনের পর আপনি মোবাইল নম্বর ও রেজিস্ট্রেশন আইডি দিয়ে আপনার ড্যাশবোর্ডে লগইন করতে পারবেন।</span>
                        </p>
                        <button type="submit" class="w-full sm:w-auto bg-emerald-600 hover:bg-emerald-700 active:scale-[0.99] text-white font-bold px-8 py-3.5 rounded-xl shadow-md hover:shadow-lg transition-all flex items-center justify-center gap-2 text-base">
                            <i data-lucide="send" class="w-4 h-4"></i>
                            <span>নিবন্ধন সম্পন্ন করুন</span>
                        </button>
                    </div>
                </form>
            </div>
        </section>

        <!-- ==========================================
             TAB 2: PLAYER LOGIN & DASHBOARD
        =========================================== -->
        <section id="section-player" class="tab-section hidden space-y-6">
            
            <!-- Player Login Screen -->
            <div id="player-login-screen" class="max-w-md mx-auto bg-white rounded-2xl shadow-sm border border-slate-200 p-6 sm:p-8 my-4">
                <div class="w-16 h-16 bg-emerald-100 text-emerald-700 rounded-2xl flex items-center justify-center mx-auto mb-4">
                    <i data-lucide="user-check" class="w-8 h-8"></i>
                </div>
                <div class="text-center mb-6">
                    <h2 class="text-xl sm:text-2xl font-bold text-slate-800">খেলোয়াড় লগইন</h2>
                    <p class="text-sm text-slate-500 mt-1">আপনার নিবন্ধনের স্ট্যাটাস, দল ও টুর্নামেন্টের সকল আপডেট দেখতে লগইন করুন।</p>
                </div>

                <form id="player-login-form" onsubmit="handlePlayerLogin(event)" class="space-y-4">
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-1">নিবন্ধিত মোবাইল নম্বর <span class="text-red-500">*</span></label>
                        <input type="tel" id="player-login-mobile" required placeholder="যেমন: 01711223344" class="w-full px-4 py-3 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 outline-none transition">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-1">রেজিস্ট্রেশন আইডি অথবা NID নম্বর <span class="text-red-500">*</span></label>
                        <input type="text" id="player-login-secret" required placeholder="যেমন: REG-2026-101 অথবা NID নম্বর" class="w-full px-4 py-3 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 outline-none transition">
                    </div>
                    <button type="submit" id="player-login-btn" class="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-3.5 rounded-xl shadow-md transition flex items-center justify-center gap-2">
                        <i data-lucide="log-in" class="w-4 h-4"></i>
                        <span>ড্যাশবোর্ডে প্রবেশ করুন</span>
                    </button>
                </form>

                <div class="mt-5 p-3 bg-slate-50 rounded-xl border border-slate-200 text-xs text-slate-500 text-center">
                    ডেমো লগইন করতে মোবাইল: <strong class="text-slate-700">01711223344</strong> এবং আইডি: <strong class="text-slate-700">REG-2026-101</strong> ব্যবহার করতে পারেন।
                </div>
            </div>

            <!-- Player Dashboard (Hidden until logged in) -->
            <div id="player-dashboard-view" class="hidden space-y-6">
                
                <!-- Top Action Bar -->
                <div class="bg-white rounded-2xl shadow-sm border border-slate-200 p-4 sm:px-6 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                    <div class="flex items-center gap-2.5">
                        <span class="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
                        <span class="text-sm font-bold text-slate-800">খেলোয়াড় ড্যাশবোর্ড</span>
                        <span id="pd-reg-badge" class="font-mono text-xs font-bold px-2.5 py-0.5 bg-emerald-100 text-emerald-800 rounded-lg">REG-000</span>
                    </div>
                    <div class="flex flex-wrap items-center gap-2">
                        <button onclick="refreshPlayerDashboard()" class="bg-teal-50 hover:bg-teal-100 text-teal-700 border border-teal-200 text-xs font-bold px-3.5 py-2 rounded-xl flex items-center gap-1.5 transition">
                            <i data-lucide="refresh-cw" class="w-3.5 h-3.5"></i>
                            <span>আপডেট রিফ্রেশ</span>
                        </button>
                        <button onclick="openLoggedInPlayerSlip()" class="bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold px-3.5 py-2 rounded-xl flex items-center gap-1.5 transition shadow-sm">
                            <i data-lucide="id-card" class="w-3.5 h-3.5"></i>
                            <span>নিবন্ধন স্লিপ / ID কার্ড</span>
                        </button>
                        <button onclick="logoutPlayer()" class="bg-red-50 hover:bg-red-100 text-red-600 border border-red-200 text-xs font-bold px-3.5 py-2 rounded-xl flex items-center gap-1.5 transition">
                            <i data-lucide="log-out" class="w-3.5 h-3.5"></i>
                            <span>লগআউট</span>
                        </button>
                    </div>
                </div>

                <!-- Live Status Overview Cards -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                    <!-- Approval Status -->
                    <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
                        <div class="flex items-center justify-between mb-2">
                            <span class="text-xs font-semibold text-slate-500">নিবন্ধন স্ট্যাটাস</span>
                            <i data-lucide="badge-check" class="w-4 h-4 text-emerald-600"></i>
                        </div>
                        <div id="pd-status-badge" class="text-lg font-bold text-amber-600">Pending (অপেক্ষমাণ)</div>
                        <p class="text-[11px] text-slate-400 mt-1">পরিচালনা পরিষদ কর্তৃক যাচাইকৃত</p>
                    </div>

                    <!-- Payment Status -->
                    <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
                        <div class="flex items-center justify-between mb-2">
                            <span class="text-xs font-semibold text-slate-500">পেমেন্ট ভেরিফিকেশন</span>
                            <i data-lucide="credit-card" class="w-4 h-4 text-amber-600"></i>
                        </div>
                        <div id="pd-payment-status" class="text-lg font-bold text-slate-800">যাচাই চলছে</div>
                        <p id="pd-trx-info" class="text-[11px] text-slate-400 mt-1 font-mono">TrxID: ---</p>
                    </div>

                    <!-- Assigned Team -->
                    <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
                        <div class="flex items-center justify-between mb-2">
                            <span class="text-xs font-semibold text-slate-500">বরাদ্দকৃত দল / গ্রুপ</span>
                            <i data-lucide="users" class="w-4 h-4 text-indigo-600"></i>
                        </div>
                        <div id="pd-team" class="text-lg font-bold text-indigo-700">নির্ধারিত হয়নি</div>
                        <p class="text-[11px] text-slate-400 mt-1">ড্র / বাছাইয়ের পর আপডেট হবে</p>
                    </div>

                    <!-- Total Votes -->
                    <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
                        <div class="flex items-center justify-between mb-2">
                            <span class="text-xs font-semibold text-slate-500">মোট প্রাপ্ত ভোট</span>
                            <i data-lucide="thumbs-up" class="w-4 h-4 text-emerald-600"></i>
                        </div>
                        <div id="pd-votes" class="text-2xl font-bold text-emerald-700">০</div>
                        <p class="text-[11px] text-slate-400 mt-1">পাবলিক ভোটিং পোল থেকে</p>
                    </div>
                </div>

                <!-- Profile Details & Committee Notice Grid -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    
                    <!-- Player Profile Card -->
                    <div class="lg:col-span-2 bg-white rounded-2xl shadow-sm border border-slate-200 p-6">
                        <h3 class="text-base font-bold text-slate-800 border-b border-slate-100 pb-3 mb-4 flex items-center gap-2">
                            <i data-lucide="user" class="w-4 h-4 text-emerald-600"></i>
                            <span>আপনার নিবন্ধিত প্রোফাইল বিবরণী</span>
                        </h3>
                        <div class="flex flex-col sm:flex-row gap-5 items-start">
                            <img id="pd-photo" src="" alt="Player Photo" class="w-28 h-32 rounded-2xl object-cover border-2 border-emerald-600 shadow-sm shrink-0 mx-auto sm:mx-0">
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-x-6 gap-y-2.5 text-sm w-full">
                                <div>
                                    <span class="text-xs text-slate-400 block">পূর্ণ নাম</span>
                                    <span id="pd-name" class="font-bold text-slate-800">---</span>
                                </div>
                                <div>
                                    <span class="text-xs text-slate-400 block">মোবাইল নম্বর</span>
                                    <span id="pd-mobile" class="font-semibold text-slate-700 font-mono">---</span>
                                </div>
                                <div>
                                    <span class="text-xs text-slate-400 block">পিতা ও মাতার নাম</span>
                                    <span id="pd-parents" class="font-medium text-slate-700">---</span>
                                </div>
                                <div>
                                    <span class="text-xs text-slate-400 block">জাতীয় পরিচয়পত্র (NID)</span>
                                    <span id="pd-nid" class="font-medium text-slate-700 font-mono">---</span>
                                </div>
                                <div>
                                    <span class="text-xs text-slate-400 block">খেলার ধরন ও পজিশন</span>
                                    <span id="pd-sport-role" class="font-semibold text-emerald-700">---</span>
                                </div>
                                <div>
                                    <span class="text-xs text-slate-400 block">জার্সি সাইজ ও নম্বর</span>
                                    <span id="pd-jersey" class="font-semibold text-slate-700">---</span>
                                </div>
                                <div class="sm:col-span-2">
                                    <span class="text-xs text-slate-400 block">পূর্ণাঙ্গ ঠিকানা</span>
                                    <span id="pd-address" class="font-medium text-slate-700">---</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Committee Remarks & Tournament Notice Board -->
                    <div class="lg:col-span-1 space-y-4">
                        <!-- Individual Remarks -->
                        <div class="bg-amber-50/80 border border-amber-200 rounded-2xl p-5">
                            <h4 class="text-sm font-bold text-amber-900 flex items-center gap-2 mb-2">
                                <i data-lucide="message-square-warning" class="w-4 h-4 text-amber-700"></i>
                                <span>আপনার জন্য কমিটির বিশেষ বার্তা</span>
                            </h4>
                            <p id="pd-remarks" class="text-sm text-slate-700 bg-white p-3 rounded-xl border border-amber-200/80">
                                এখনো কোনো বিশেষ মন্তব্য যুক্ত করা হয়নি।
                            </p>
                        </div>

                        <!-- Global Tournament Notice Board -->
                        <div class="bg-emerald-50/80 border border-emerald-200 rounded-2xl p-5">
                            <h4 class="text-sm font-bold text-emerald-900 flex items-center gap-2 mb-2">
                                <i data-lucide="megaphone" class="w-4 h-4 text-emerald-700"></i>
                                <span>টুর্নামেন্ট নোটিশ বোর্ড ও আপডেট</span>
                            </h4>
                            <div id="pd-global-notice" class="text-sm text-slate-700 bg-white p-3.5 rounded-xl border border-emerald-200/80 leading-relaxed">
                                আগামী ২০ নভেম্বর সকাল ৯টায় উদ্বোধনী ম্যাচ ও জার্সি বিতরণ অনুষ্ঠিত হবে। সকল নিবন্ধিত খেলোয়াড়কে নিবন্ধন স্লিপসহ উপস্থিত থাকার জন্য অনুরোধ করা হলো।
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <!-- ==========================================
             TAB 3: ONLINE VOTING SYSTEM
        =========================================== -->
        <section id="section-voting" class="tab-section hidden space-y-6">
            <div class="bg-white rounded-2xl shadow-sm border border-slate-200 p-6">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-100 pb-4 mb-6">
                    <div>
                        <span class="text-xs font-bold uppercase tracking-wider text-emerald-600 bg-emerald-50 px-2.5 py-1 rounded-lg">পাবলিক পোল</span>
                        <h2 class="text-2xl font-bold text-slate-800 mt-1">টুর্নামেন্টের জনপ্রিয় খেলোয়াড় নির্বাচন</h2>
                        <p class="text-sm text-slate-500">আপনার পছন্দের খেলোয়াড়কে ভোট দিন। একজন ভোটার কেবল একবারই ভোট দিতে পারবেন।</p>
                    </div>
                    <div class="bg-slate-50 border border-slate-200 px-4 py-2.5 rounded-xl text-center">
                        <div class="text-xs text-slate-500">মোট সংগৃহীত ভোট</div>
                        <div id="total-votes-display" class="text-2xl font-bold text-emerald-700">০</div>
                    </div>
                </div>

                <!-- Voter Verification Input -->
                <div class="bg-emerald-50/70 border border-emerald-200 rounded-2xl p-4 mb-6">
                    <label class="block text-sm font-bold text-emerald-900 mb-1.5 flex items-center gap-1.5">
                        <i data-lucide="id-card" class="w-4 h-4"></i>
                        <span>ভোট দেওয়ার জন্য আপনার মোবাইল নম্বর বা NID নম্বর দিন:</span>
                    </label>
                    <div class="flex flex-col sm:flex-row gap-3">
                        <input type="text" id="voter-id-input" placeholder="১১ ডিজিটের মোবাইল নম্বর অথবা NID নম্বর লিখুন" class="flex-grow px-4 py-2.5 rounded-xl border border-emerald-300 focus:ring-2 focus:ring-emerald-500 outline-none bg-white">
                        <span class="text-xs text-emerald-700 flex items-center">
                            * ডুপ্লিকেট ভোট রোধে নম্বর যাচাই করা হয়
                        </span>
                    </div>
                </div>

                <!-- Candidates List -->
                <div id="voting-candidates-grid" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                </div>
            </div>
        </section>

        <!-- ==========================================
             TAB 4: TOURNAMENT COMMITTEE / ADMIN PANEL
        =========================================== -->
        <section id="section-admin" class="tab-section hidden">
            
            <!-- Admin Login Lock Screen -->
            <div id="admin-lock-screen" class="max-w-md mx-auto bg-white rounded-2xl shadow-sm border border-slate-200 p-8 text-center my-6">
                <div class="w-16 h-16 bg-emerald-100 text-emerald-700 rounded-2xl flex items-center justify-center mx-auto mb-4">
                    <i data-lucide="shield-alert" class="w-8 h-8"></i>
                </div>
                <h2 class="text-xl font-bold text-slate-800">পরিচালনা পরিষদ লগইন</h2>
                <p class="text-sm text-slate-500 mt-1 mb-6">শুধুমাত্র অনুমোদিত জিমেইল ও গোপন পাসওয়ার্ড দিয়ে প্রবেশ করুন।</p>
                
                <div class="space-y-4 text-left">
                    <div>
                        <label class="block text-xs font-bold text-slate-700 mb-1">অ্যাডমিন জিমেইল (Gmail) <span class="text-red-500">*</span></label>
                        <input type="email" id="admin-email-input" placeholder="আপনার অনুমোদিত জিমেইল দিন..." class="w-full text-sm px-4 py-3 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-slate-700 mb-1">গোপন পাসওয়ার্ড / পিন <span class="text-red-500">*</span></label>
                        <input type="password" id="admin-pin-input" placeholder="আপনার গোপন পাসওয়ার্ড লিখুন" class="w-full text-center tracking-widest text-base font-bold px-4 py-3 rounded-xl border border-slate-300 focus:ring-2 focus:ring-emerald-500 outline-none">
                    </div>
                    <button onclick="unlockAdmin()" class="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-3 rounded-xl shadow transition">
                        ড্যাশবোর্ডে প্রবেশ করুন
                    </button>
                    <p id="admin-setup-hint" class="text-xs text-slate-500 bg-slate-50 py-2 px-3 rounded-lg border border-slate-200 text-center">
                        নির্ধারিত অ্যাডমিন জিমেইল (<strong class="text-slate-700">mohammadrayhantalukder334@gmail.com</strong>) ও আপনার গোপন পাসওয়ার্ড দিয়ে প্রবেশ করুন।
                    </p>
                </div>
            </div>

            <!-- Admin Dashboard Content -->
            <div id="admin-dashboard" class="hidden space-y-6">
                <!-- Stats Overview Cards -->
                <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
                    <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
                        <span class="text-xs font-semibold text-slate-500">মোট নিবন্ধন</span>
                        <div id="stat-total" class="text-2xl font-bold text-slate-800 mt-1">0</div>
                    </div>
                    <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
                        <span class="text-xs font-semibold text-emerald-600">অনুমোদিত (Approved)</span>
                        <div id="stat-approved" class="text-2xl font-bold text-emerald-700 mt-1">0</div>
                    </div>
                    <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
                        <span class="text-xs font-semibold text-amber-600">অপেক্ষমাণ (Pending)</span>
                        <div id="stat-pending" class="text-2xl font-bold text-amber-600 mt-1">0</div>
                    </div>
                    <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
                        <span class="text-xs font-semibold text-indigo-600">মোট ভোট</span>
                        <div id="stat-votes" class="text-2xl font-bold text-indigo-700 mt-1">0</div>
                    </div>
                </div>

                <!-- Main Committee Panel Card -->
                <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
                    <!-- Top Action Bar -->
                    <div class="p-4 sm:p-5 border-b border-slate-200 flex flex-col lg:flex-row lg:items-center justify-between gap-3 bg-slate-50/70">
                        <div>
                            <h3 class="text-lg font-bold text-slate-800 flex items-center gap-2">
                                <i data-lucide="sliders" class="w-5 h-5 text-emerald-600"></i>
                                <span>পরিচালনা পরিষদ নিয়ন্ত্রণ প্যানেল</span>
                            </h3>
                            <p class="text-xs text-slate-500">নোটিশ প্রকাশ, গুগল শিট সিঙ্ক, পাসওয়ার্ড পরিবর্তন ও খেলোয়াড়দের তথ্য নিয়ন্ত্রণ করুন</p>
                        </div>
                        <div class="flex flex-wrap items-center gap-2">
                            <button onclick="fetchPlayersFromGoogleSheet()" class="bg-teal-600 hover:bg-teal-700 text-white text-xs font-bold px-3.5 py-2 rounded-xl flex items-center gap-1.5 transition shadow-sm">
                                <i data-lucide="refresh-cw" class="w-3.5 h-3.5"></i>
                                <span>অনলাইন ডেটা লোড</span>
                            </button>
                            <button onclick="togglePinChangeModal()" class="bg-amber-600 hover:bg-amber-700 text-white text-xs font-bold px-3.5 py-2 rounded-xl flex items-center gap-1.5 transition shadow-sm">
                                <i data-lucide="settings" class="w-3.5 h-3.5"></i>
                                <span>নোটিশ, পিন ও সেটিংস</span>
                            </button>
                            <button onclick="exportBackupJSON()" class="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold px-3.5 py-2 rounded-xl flex items-center gap-1.5 transition shadow-sm">
                                <i data-lucide="download" class="w-3.5 h-3.5"></i>
                                <span>ব্যাকআপ (JSON)</span>
                            </button>
                            <label class="cursor-pointer bg-slate-700 hover:bg-slate-800 text-white text-xs font-bold px-3.5 py-2 rounded-xl flex items-center gap-1.5 transition shadow-sm">
                                <i data-lucide="upload" class="w-3.5 h-3.5"></i>
                                <span>রিস্টোর</span>
                                <input type="file" accept=".json" onchange="importBackupJSON(event)" class="hidden">
                            </label>
                            <button onclick="exportCSV()" class="bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold px-3.5 py-2 rounded-xl flex items-center gap-1.5 transition shadow-sm">
                                <i data-lucide="file-spreadsheet" class="w-3.5 h-3.5"></i>
                                <span>CSV ডাউনলোড</span>
                            </button>
                            <button onclick="lockAdmin()" class="bg-red-100 hover:bg-red-200 text-red-700 text-xs font-bold px-3.5 py-2 rounded-xl flex items-center gap-1.5 transition">
                                <i data-lucide="lock" class="w-3.5 h-3.5"></i>
                                <span>লক করুন</span>
                            </button>
                        </div>
                    </div>

                    <!-- Settings, Tournament Notice & PIN Box -->
                    <div id="change-pin-box" class="hidden p-5 bg-amber-50 border-b border-amber-200 space-y-4">
                        <div>
                            <label class="block text-xs font-bold text-emerald-900 mb-1">টুর্নামেন্ট নোটিশ বোর্ড (সকল খেলোয়াড়ের ড্যাশবোর্ডে দেখাবে):</label>
                            <textarea id="global-notice-input" rows="2" placeholder="খেলোয়াড়দের জন্য গুরুত্বপূর্ণ আপডেট বা খেলার সময়সূচি লিখুন..." class="w-full px-3.5 py-2 rounded-xl border border-emerald-300 text-sm outline-none focus:ring-2 focus:ring-emerald-500 bg-white"></textarea>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 border-t border-amber-200/80 pt-3">
                            <div>
                                <label class="block text-xs font-bold text-amber-900 mb-1">অনুমোদিত অ্যাডমিন জিমেইল:</label>
                                <input type="email" id="new-admin-email" readonly class="w-full px-3.5 py-2 rounded-xl border border-amber-300 text-sm bg-slate-100 text-slate-600 cursor-not-allowed">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-amber-900 mb-1">নতুন গোপন পাসওয়ার্ড / পিন (পরিবর্তন করতে চাইলে লিখুন):</label>
                                <input type="password" id="new-admin-pin" placeholder="নতুন পাসওয়ার্ড লিখুন..." class="w-full px-3.5 py-2 rounded-xl border border-amber-300 text-sm outline-none focus:ring-2 focus:ring-amber-500 bg-white">
                            </div>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-emerald-900 mb-1">Google Script Web App URL (গুগল শিটে তথ্য সংরক্ষণ ও লোড করার লিংক):</label>
                            <input type="url" id="google-script-url-input" placeholder="https://script.google.com/macros/s/.../exec" class="w-full px-3.5 py-2 rounded-xl border border-emerald-300 text-xs font-mono outline-none focus:ring-2 focus:ring-emerald-500 bg-white">
                        </div>
                        <div class="flex items-center gap-2 pt-1">
                            <button onclick="saveAdminSecuritySettings()" class="bg-emerald-600 hover:bg-emerald-700 text-white text-xs sm:text-sm font-bold px-5 py-2.5 rounded-xl transition shadow-sm">
                                নোটিশ, পিন ও সেটিংস সেভ করুন
                            </button>
                            <button onclick="togglePinChangeModal()" class="bg-white hover:bg-slate-100 text-slate-600 border border-slate-300 text-xs sm:text-sm font-semibold px-4 py-2.5 rounded-xl transition">
                                বাতিল
                            </button>
                        </div>
                    </div>

                    <!-- Search & Filter Controls -->
                    <div class="p-4 bg-slate-50 border-b border-slate-200 grid grid-cols-1 sm:grid-cols-3 gap-3">
                        <input type="text" id="admin-search" onkeyup="renderAdminList()" placeholder="নাম, মোবাইল, ID বা TrxID খুঁজুন..." class="px-3.5 py-2 rounded-xl border border-slate-300 text-sm outline-none focus:ring-2 focus:ring-emerald-500 bg-white">
                        <select id="admin-filter-status" onchange="renderAdminList()" class="px-3.5 py-2 rounded-xl border border-slate-300 text-sm outline-none bg-white">
                            <option value="ALL">সকল স্ট্যাটাস (All)</option>
                            <option value="Pending">অপেক্ষমাণ (Pending)</option>
                            <option value="Approved">অনুমোদিত (Approved)</option>
                            <option value="Rejected">বাতিল (Rejected)</option>
                        </select>
                        <select id="admin-filter-sport" onchange="renderAdminList()" class="px-3.5 py-2 rounded-xl border border-slate-300 text-sm outline-none bg-white">
                            <option value="ALL">সকল খেলা (All Sports)</option>
                            <option value="ক্রিকেট">ক্রিকেট</option>
                            <option value="ফুটবল">ফুটবল</option>
                            <option value="ব্যাডমিন্টন">ব্যাডমিন্টন</option>
                            <option value="ভলিবল">ভলিবল</option>
                        </select>
                    </div>

                    <!-- Players List Container -->
                    <div id="admin-players-list" class="divide-y divide-slate-200">
                    </div>
                </div>
            </div>
        </section>

    </main>

    <!-- Slip / ID Card Modal -->
    <div id="slip-modal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 hidden items-center justify-center p-4 overflow-y-auto">
        <div class="bg-white rounded-2xl max-w-lg w-full shadow-2xl overflow-hidden my-auto">
            <div id="printable-slip" class="p-6 bg-white">
                <div class="border-b-2 border-emerald-700 pb-3 mb-4 flex items-center justify-between">
                    <div>
                        <h3 class="text-lg font-bold text-emerald-800">বার্ষিক ক্রীড়া টুর্নামেন্ট ২০২৬</h3>
                        <p class="text-xs text-slate-500">অফিসিয়াল খেলোয়াড় নিবন্ধন স্লিপ</p>
                    </div>
                    <span id="slip-reg-id" class="font-mono text-xs font-bold bg-emerald-100 text-emerald-800 px-2.5 py-1 rounded-lg">REG-000</span>
                </div>

                <div class="flex gap-4 items-start mb-4">
                    <img id="slip-photo" src="" alt="Player" class="w-24 h-28 object-cover rounded-xl border-2 border-emerald-600 shrink-0">
                    <div class="text-xs space-y-1.5 text-slate-700">
                        <p class="text-base font-bold text-slate-900" id="slip-name"></p>
                        <p><strong>পিতা:</strong> <span id="slip-father"></span></p>
                        <p><strong>মাতা:</strong> <span id="slip-mother"></span></p>
                        <p><strong>মোবাইল:</strong> <span id="slip-mobile"></span></p>
                        <p><strong>NID:</strong> <span id="slip-nid" class="font-mono"></span></p>
                    </div>
                </div>

                <div class="bg-slate-50 rounded-xl p-3 text-xs space-y-1.5 border border-slate-200 mb-4">
                    <p><strong>ঠিকানা:</strong> <span id="slip-address"></span></p>
                    <p><strong>খেলা ও পজিশন:</strong> <span id="slip-sport"></span></p>
                    <p><strong>জার্সি সাইজ ও নম্বর:</strong> <span id="slip-jersey"></span></p>
                    <p><strong>পেমেন্ট:</strong> <span id="slip-payment"></span></p>
                </div>

                <div class="border border-emerald-300 bg-emerald-50/50 rounded-xl p-2.5 text-[11px] text-slate-700 mb-6">
                    <strong>অঙ্গীকারনামা:</strong> আমি সজ্ঞানে অঙ্গীকার করছি যে, উপরে প্রদত্ত সকল তথ্য সত্য এবং টুর্নামেন্ট পরিচালনা পরিষদের সকল নিয়ম ও সিদ্ধান্ত মেনে চলব।
                </div>

                <div class="flex justify-between items-end pt-4 text-[11px] font-semibold text-slate-600">
                    <div class="border-t border-slate-400 pt-1 px-3">খেলোয়াড়ের স্বাক্ষর</div>
                    <div class="border-t border-slate-400 pt-1 px-3">পরিচালনা পরিষদের স্বাক্ষর</div>
                </div>
            </div>

            <!-- Modal Footer Actions -->
            <div class="px-6 pb-6 pt-2 flex gap-3 no-print">
                <button onclick="window.print()" class="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-2.5 px-4 rounded-xl flex items-center justify-center gap-2 transition shadow-sm">
                    <i data-lucide="printer" class="w-4 h-4"></i>
                    <span>প্রিন্ট / PDF সেভ করুন</span>
                </button>
                <button onclick="closeSlipModal()" class="bg-slate-200 hover:bg-slate-300 text-slate-700 font-semibold py-2.5 px-5 rounded-xl transition">
                    বন্ধ করুন
                </button>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 mt-auto py-5 text-center text-xs sm:text-sm text-slate-500">
        <div class="max-w-6xl mx-auto px-4">
            <p>© ২০২৬ টুর্নামেন্ট পরিচালনা পরিষদ। সর্বস্বত্ব সংরক্ষিত।</p>
        </div>
    </footer>

    <!-- Application Logic -->
    <script>
        // --- 1. INITIAL DATA & STATE ---
        const sportRoles = {
            "ক্রিকেট": ["ব্যাটসম্যান (Batsman)", "বোলার (Bowler)", "অলরাউন্ডার (All-rounder)", "উইকেটকিপার (Wicketkeeper)"],
            "ফুটবল": ["স্ট্রাইকার (Striker)", "মিডফিল্ডার (Midfielder)", "ডিফেন্ডার (Defender)", "গোলকিপার (Goalkeeper)"],
            "ব্যাডমিন্টন": ["একক (Singles)", "দ্বৈত (Doubles)", "মিক্সড ডাবলস (Mixed Doubles)"],
            "ভলিবল": ["অ্যাটাকার / স্পাইকার", "সেটার (Setter)", "ব্লকার (Blocker)", "লিবারো (Libero)"]
        };

        const defaultPlayers = [
            {
                id: "REG-2026-101",
                photo: "https://placehold.co/300x350/059669/ffffff?text=সাকিব+আল+হাসান",
                fullName: "মোঃ রাফিউজ্জামান সাকিব",
                fatherName: "মোঃ আব্দুল করিম",
                motherName: "মিসেস রাবেয়া খাতুন",
                mobile: "01711223344",
                nidNumber: "1998456789123",
                district: "কুমিল্লা",
                upazila: "দেবিদ্বার",
                unionName: "বরকামতা",
                village: "নবিয়াবাদ",
                para: "উত্তর পাড়া",
                sportType: "ক্রিকেট",
                playingRole: "অলরাউন্ডার (All-rounder)",
                jerseySize: "L",
                jerseyNumber: "75",
                experience: "উপজেলা প্রিমিয়ার লিগ চ্যাম্পিয়ন দল ২০২৫",
                paymentMethod: "বিকাশ (bKash)",
                senderNumber: "01711223344",
                trxId: "BK98X76Y5Z",
                paymentVerified: true,
                status: "Approved",
                assignedTeam: "গ্রুপ এ - পদ্মা টাইগার্স",
                remarks: "ডকুমেন্ট ও পেমেন্ট সঠিক পাওয়া গেছে। আগামী ২০ তারিখ মাঠে উপস্থিত থাকবেন।",
                votes: 14
            },
            {
                id: "REG-2026-102",
                photo: "https://placehold.co/300x350/0284c7/ffffff?text=তানভীর+হোসেন",
                fullName: "তানভীর হোসেন জয়",
                fatherName: "মোঃ শফিকুল ইসলাম",
                motherName: "মিসেস সালমা বেগম",
                mobile: "01812345678",
                nidNumber: "2001789456123",
                district: "বগুড়া",
                upazila: "শাজাহানপুর",
                unionName: "আড়িয়া",
                village: "নয়ামাইল",
                para: "দক্ষিণ মহল্লা",
                sportType: "ফুটবল",
                playingRole: "স্ট্রাইকার (Striker)",
                jerseySize: "M",
                jerseyNumber: "10",
                experience: "আন্তঃইউনিয়ন ফুটবল টুর্নামেন্ট সেরা গোলদাতা",
                paymentMethod: "নগদ (Nagad)",
                senderNumber: "01812345678",
                trxId: "NG45A12B8C",
                paymentVerified: false,
                status: "Pending",
                assignedTeam: "নির্ধারিত হয়নি",
                remarks: "পেমেন্ট যাচাইয়ের অপেক্ষায়",
                votes: 9
            }
        ];

        const DEFAULT_TOURNAMENT_NOTICE = "আগামী ২০ নভেম্বর সকাল ৯টায় উদ্বোধনী ম্যাচ ও জার্সি বিতরণ অনুষ্ঠিত হবে। সকল নিবন্ধিত খেলোয়াড়কে নিবন্ধন স্লিপসহ উপস্থিত থাকার জন্য অনুরোধ করা হলো।";

        let players = JSON.parse(localStorage.getItem('tournament_players_bn')) || defaultPlayers;
        let votedNumbers = JSON.parse(localStorage.getItem('tournament_voters_bn')) || [];
        let uploadedPhotoDataUrl = "https://placehold.co/300x350/059669/ffffff?text=Player";
        let loggedInPlayerId = sessionStorage.getItem('logged_in_player_id') || null;

        // Locked Admin Email & SHA-256 Hash of 'Mohammadrayhan@334CFBB&O'
        const PERMANENT_ADMIN_EMAIL = "mohammadrayhantalukder334@gmail.com";
        const DEFAULT_PIN_HASH = "82325b8b7d484d1a5068c74a448b532f1e10e965e794f973d98f92e149c6982a";

        async function hashPin(pinText) {
            const encoder = new TextEncoder();
            const data = encoder.encode(pinText);
            const hashBuffer = await crypto.subtle.digest('SHA-256', data);
            const hashArray = Array.from(new Uint8Array(hashBuffer));
            return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
        }

        function saveState() {
            localStorage.setItem('tournament_players_bn', JSON.stringify(players));
            localStorage.setItem('tournament_voters_bn', JSON.stringify(votedNumbers));
        }

        function showToast(message, type = "info") {
            const container = document.getElementById('toast-container');
            const toast = document.createElement('div');
            const colors = {
                success: "bg-emerald-700 text-white border-emerald-800",
                error: "bg-red-600 text-white border-red-700",
                info: "bg-slate-800 text-white border-slate-900"
            };
            toast.className = `${colors[type] || colors.info} px-4 py-3 rounded-xl shadow-lg border text-sm font-medium pointer-events-auto transition-all`;
            toast.textContent = message;
            container.appendChild(toast);
            setTimeout(() => toast.remove(), 4000);
        }

        // Tab Navigation
        function switchTab(tabName) {
            document.querySelectorAll('.tab-section').forEach(sec => sec.classList.add('hidden'));
            document.getElementById(`section-${tabName}`).classList.remove('hidden');

            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.classList.remove('bg-white', 'text-emerald-800', 'shadow-sm');
                btn.classList.add('text-emerald-100', 'hover:bg-white/10');
            });
            const activeBtn = document.getElementById(`tab-${tabName}`);
            activeBtn.classList.add('bg-white', 'text-emerald-800', 'shadow-sm');
            activeBtn.classList.remove('text-emerald-100', 'hover:bg-white/10');

            if (tabName === 'voting') renderVotingSection();
            if (tabName === 'player' && loggedInPlayerId) renderPlayerDashboard();
            lucide.createIcons();
        }

        function updateRoles() {
            const sport = document.getElementById('sportType').value;
            const roleSelect = document.getElementById('playingRole');
            const roles = sportRoles[sport] || [];
            roleSelect.innerHTML = roles.map(r => `<option value="${r}">${r}</option>`).join('');
        }

        function previewImage(event) {
            const file = event.target.files[0];
            if (!file) return;
            if (file.size > 2 * 1024 * 1024) {
                showToast("ছবির সাইজ ২ মেগাবাইটের কম হতে হবে!", "error");
                event.target.value = "";
                return;
            }
            const reader = new FileReader();
            reader.onload = function(e) {
                uploadedPhotoDataUrl = e.target.result;
                document.getElementById('photo-preview').src = uploadedPhotoDataUrl;
            };
            reader.readAsDataURL(file);
        }

        async function syncToGoogleSheet(playerObj) {
            const scriptUrl = localStorage.getItem('tournament_google_script_url');
            if (!scriptUrl) return;
            try {
                await fetch(scriptUrl, {
                    method: "POST",
                    mode: "no-cors",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({
                        regId: playerObj.id,
                        name: playerObj.fullName,
                        fatherName: playerObj.fatherName,
                        motherName: playerObj.motherName,
                        phone: playerObj.mobile,
                        nid: playerObj.nidNumber,
                        district: playerObj.district,
                        upazila: playerObj.upazila,
                        union: playerObj.unionName,
                        village: playerObj.village,
                        para: playerObj.para,
                        sport: playerObj.sportType,
                        position: playerObj.playingRole,
                        jerseySize: playerObj.jerseySize,
                        jerseyNo: playerObj.jerseyNumber,
                        paymentMethod: playerObj.paymentMethod,
                        senderNumber: playerObj.senderNumber,
                        trxId: playerObj.trxId,
                        photoBase64: playerObj.photo
                    })
                });
            } catch (err) {
                console.error("Google Sheet Sync Error:", err);
            }
        }

        document.getElementById('registration-form').addEventListener('submit', async function(e) {
            e.preventDefault();
            const newPlayer = {
                id: "REG-2026-" + Math.floor(100 + Math.random() * 900),
                photo: uploadedPhotoDataUrl,
                fullName: document.getElementById('fullName').value.trim(),
                fatherName: document.getElementById('fatherName').value.trim(),
                motherName: document.getElementById('motherName').value.trim(),
                mobile: document.getElementById('mobile').value.trim(),
                nidNumber: document.getElementById('nidNumber').value.trim(),
                district: document.getElementById('district').value.trim(),
                upazila: document.getElementById('upazila').value.trim(),
                unionName: document.getElementById('unionName').value.trim(),
                village: document.getElementById('village').value.trim(),
                para: document.getElementById('para').value.trim(),
                sportType: document.getElementById('sportType').value,
                playingRole: document.getElementById('playingRole').value,
                jerseySize: document.getElementById('jerseySize').value,
                jerseyNumber: document.getElementById('jerseyNumber').value || "N/A",
                experience: document.getElementById('experience').value.trim(),
                paymentMethod: document.getElementById('paymentMethod').value,
                senderNumber: document.getElementById('senderNumber').value.trim(),
                trxId: document.getElementById('trxId').value.trim().toUpperCase(),
                paymentVerified: false,
                status: "Pending",
                assignedTeam: "নির্ধারিত হয়নি",
                remarks: "",
                votes: 0
            };

            players.unshift(newPlayer);
            saveState();
            await syncToGoogleSheet(newPlayer);
            
            // Auto-login newly registered player to their dashboard
            loggedInPlayerId = newPlayer.id;
            sessionStorage.setItem('logged_in_player_id', newPlayer.id);
            
            showToast(`নিবন্ধন সফল! আপনার আইডি: ${newPlayer.id}`, "success");
            openSlipModal(newPlayer);
            this.reset();
            uploadedPhotoDataUrl = "https://placehold.co/300x350/059669/ffffff?text=Player";
            document.getElementById('photo-preview').src = "https://placehold.co/300x350/e2e8f0/64748b?text=ছবি+দিন";
            updateRoles();
        });

        // --- 2. PLAYER LOGIN & DASHBOARD LOGIC ---
        async function handlePlayerLogin(e) {
            e.preventDefault();
            const mobile = document.getElementById('player-login-mobile').value.trim();
            const secret = document.getElementById('player-login-secret').value.trim().toUpperCase();

            if (!mobile || !secret) {
                showToast("মোবাইল নম্বর এবং রেজিস্ট্রেশন আইডি অথবা NID দিন!", "error");
                return;
            }

            // Check live from Google Sheet if configured
            const scriptUrl = localStorage.getItem('tournament_google_script_url');
            if (scriptUrl) {
                try {
                    showToast("অনলাইন ডেটাবেস যাচাই করা হচ্ছে...", "info");
                    const res = await fetch(`${scriptUrl}?action=player&mobile=${encodeURIComponent(mobile)}&secret=${encodeURIComponent(secret)}`);
                    const data = await res.json();
                    if (data.status === "success" && data.player) {
                        const existingIdx = players.findIndex(p => p.id === data.player.id);
                        if (existingIdx >= 0) {
                            players[existingIdx] = { ...players[existingIdx], ...data.player };
                        } else {
                            players.unshift(data.player);
                        }
                        saveState();
                    }
                } catch (err) {
                    console.warn("Online player fetch skipped/failed, falling back to local data.", err);
                }
            }

            // Match player in state by Mobile + (Reg ID or NID)
            const matchedPlayer = players.find(p => 
                p.mobile === mobile && 
                (p.id.toUpperCase() === secret || String(p.nidNumber).toUpperCase() === secret)
            );

            if (matchedPlayer) {
                loggedInPlayerId = matchedPlayer.id;
                sessionStorage.setItem('logged_in_player_id', matchedPlayer.id);
                renderPlayerDashboard();
                showToast(`স্বাগতম, ${matchedPlayer.fullName}!`, "success");
            } else {
                showToast("তথ্য মেলেনি! সঠিক নিবন্ধিত মোবাইল নম্বর এবং রেজিস্ট্রেশন আইডি বা NID দিন।", "error");
            }
        }

        function renderPlayerDashboard() {
            const player = players.find(p => p.id === loggedInPlayerId);
            if (!player) {
                logoutPlayer();
                return;
            }

            document.getElementById('player-login-screen').classList.add('hidden');
            document.getElementById('player-dashboard-view').classList.remove('hidden');

            document.getElementById('pd-reg-badge').textContent = player.id;
            document.getElementById('pd-photo').src = player.photo;
            document.getElementById('pd-name').textContent = player.fullName;
            document.getElementById('pd-mobile').textContent = player.mobile;
            document.getElementById('pd-parents').textContent = `${player.fatherName} ও ${player.motherName}`;
            document.getElementById('pd-nid').textContent = player.nidNumber;
            document.getElementById('pd-sport-role').textContent = `${player.sportType} (${player.playingRole})`;
            document.getElementById('pd-jersey').textContent = `সাইজ: ${player.jerseySize} | নম্বর: #${player.jerseyNumber}`;
            document.getElementById('pd-address').textContent = `পাড়া: ${player.para}, গ্রাম: ${player.village}, ইউনিয়ন: ${player.unionName}, উপজেলা: ${player.upazila}, জেলা: ${player.district}`;

            // Status Cards
            const statusEl = document.getElementById('pd-status-badge');
            if (player.status === 'Approved') {
                statusEl.textContent = "Approved (অনুমোদিত)";
                statusEl.className = "text-lg font-bold text-emerald-700";
            } else if (player.status === 'Rejected') {
                statusEl.textContent = "Rejected (বাতিল)";
                statusEl.className = "text-lg font-bold text-red-600";
            } else {
                statusEl.textContent = "Pending (অপেক্ষমাণ)";
                statusEl.className = "text-lg font-bold text-amber-600";
            }

            const payEl = document.getElementById('pd-payment-status');
            if (player.paymentVerified) {
                payEl.textContent = "Verified (নিশ্চিত)";
                payEl.className = "text-lg font-bold text-emerald-700";
            } else {
                payEl.textContent = "Unverified (যাচাই চলছে)";
                payEl.className = "text-lg font-bold text-amber-600";
            }
            document.getElementById('pd-trx-info').textContent = `${player.paymentMethod} • TrxID: ${player.trxId}`;

            document.getElementById('pd-team').textContent = player.assignedTeam || "নির্ধারিত হয়নি";
            document.getElementById('pd-votes').textContent = player.votes || 0;

            // Remarks & Global Notice
            document.getElementById('pd-remarks').textContent = player.remarks && player.remarks.trim() !== "" 
                ? player.remarks 
                : "আপনার আবেদনটি পর্যালোচনাধীন রয়েছে। কোনো নির্দেশনা থাকলে এখানে দেখাবে।";

            const savedNotice = localStorage.getItem('tournament_global_notice') || DEFAULT_TOURNAMENT_NOTICE;
            document.getElementById('pd-global-notice').textContent = savedNotice;

            lucide.createIcons();
        }

        async function refreshPlayerDashboard() {
            const player = players.find(p => p.id === loggedInPlayerId);
            if (!player) return;

            const scriptUrl = localStorage.getItem('tournament_google_script_url');
            if (scriptUrl) {
                try {
                    showToast("সর্বশেষ আপডেট আনা হচ্ছে...", "info");
                    const res = await fetch(`${scriptUrl}?action=player&mobile=${encodeURIComponent(player.mobile)}&secret=${encodeURIComponent(player.id)}`);
                    const data = await res.json();
                    if (data.status === "success" && data.player) {
                        const idx = players.findIndex(p => p.id === player.id);
                        if (idx >= 0) players[idx] = { ...players[idx], ...data.player };
                        saveState();
                    }
                } catch (e) {
                    console.warn(e);
                }
            }
            renderPlayerDashboard();
            showToast("ড্যাশবোর্ডের তথ্য রিফ্রেশ করা হয়েছে!", "success");
        }

        function openLoggedInPlayerSlip() {
            const player = players.find(p => p.id === loggedInPlayerId);
            if (player) openSlipModal(player);
        }

        function logoutPlayer() {
            loggedInPlayerId = null;
            sessionStorage.removeItem('logged_in_player_id');
            document.getElementById('player-dashboard-view').classList.add('hidden');
            document.getElementById('player-login-screen').classList.remove('hidden');
            document.getElementById('player-login-form').reset();
            showToast("খেলোয়াড় ড্যাশবোর্ড থেকে লগআউট করা হয়েছে।", "info");
        }

        // --- 3. SLIP MODAL FUNCTIONS ---
        function openSlipModal(p) {
            document.getElementById('slip-reg-id').textContent = p.id;
            document.getElementById('slip-photo').src = p.photo;
            document.getElementById('slip-name').textContent = p.fullName;
            document.getElementById('slip-father').textContent = p.fatherName;
            document.getElementById('slip-mother').textContent = p.motherName;
            document.getElementById('slip-mobile').textContent = p.mobile;
            document.getElementById('slip-nid').textContent = p.nidNumber;
            document.getElementById('slip-address').textContent = `${p.para}, ${p.village}, ${p.unionName}, ${p.upazila}, ${p.district}`;
            document.getElementById('slip-sport').textContent = `${p.sportType} (${p.playingRole})`;
            document.getElementById('slip-jersey').textContent = `${p.jerseySize} (#${p.jerseyNumber})`;
            document.getElementById('slip-payment').textContent = `${p.paymentMethod} - TrxID: ${p.trxId}`;

            const modal = document.getElementById('slip-modal');
            modal.classList.remove('hidden');
            modal.classList.add('flex');
            lucide.createIcons();
        }

        function closeSlipModal() {
            const modal = document.getElementById('slip-modal');
            modal.classList.add('hidden');
            modal.classList.remove('flex');
        }

        // --- 4. VOTING SECTION ---
        function renderVotingSection() {
            const grid = document.getElementById('voting-candidates-grid');
            const totalVotes = players.reduce((sum, p) => sum + (p.votes || 0), 0);
            document.getElementById('total-votes-display').textContent = totalVotes;

            grid.innerHTML = players.map(p => `
                <div class="border border-slate-200 rounded-2xl p-4 flex items-center justify-between gap-4 hover:border-emerald-300 transition bg-slate-50/50">
                    <div class="flex items-center gap-3">
                        <img src="${p.photo}" alt="${p.fullName}" class="w-14 h-14 rounded-xl object-cover border border-slate-300">
                        <div>
                            <h4 class="font-bold text-slate-800 text-sm sm:text-base">${p.fullName}</h4>
                            <p class="text-xs text-slate-500">${p.sportType} • ${p.playingRole}</p>
                            <span class="inline-block mt-1 text-xs font-bold text-emerald-700 bg-emerald-100 px-2 py-0.5 rounded-md">
                                প্রাপ্ত ভোট: ${p.votes || 0}
                            </span>
                        </div>
                    </div>
                    <button onclick="castVote('${p.id}')" class="bg-emerald-600 hover:bg-emerald-700 text-white text-xs sm:text-sm font-bold px-4 py-2.5 rounded-xl shadow-sm transition shrink-0 flex items-center gap-1.5">
                        <i data-lucide="thumbs-up" class="w-3.5 h-3.5"></i>
                        <span>ভোট দিন</span>
                    </button>
                </div>
            `).join('');
            lucide.createIcons();
        }

        function castVote(playerId) {
            const voterId = document.getElementById('voter-id-input').value.trim();
            if (voterId.length < 10) {
                showToast("ভোট দেওয়ার জন্য সঠিক ১১ ডিজিটের মোবাইল বা NID নম্বর দিন!", "error");
                return;
            }
            if (votedNumbers.includes(voterId)) {
                showToast("এই নম্বর থেকে ইতিমধ্যে ভোট দেওয়া হয়েছে!", "error");
                return;
            }
            const player = players.find(p => p.id === playerId);
            if (player) {
                player.votes = (player.votes || 0) + 1;
                votedNumbers.push(voterId);
                saveState();
                renderVotingSection();
                showToast(`${player.fullName}-কে আপনার ভোট সফলভাবে গৃহীত হয়েছে!`, "success");
            }
        }

        // --- 5. TOURNAMENT COMMITTEE / ADMIN PANEL ---
        async function unlockAdmin() {
            const email = document.getElementById('admin-email-input').value.trim().toLowerCase();
            const pin = document.getElementById('admin-pin-input').value.trim();

            if (!email || !email.includes('@gmail.com')) {
                showToast("অনুগ্রহ করে আপনার সঠিক জিমেইল (@gmail.com) লিখুন।", "error");
                return;
            }
            if (!pin) {
                showToast("অনুগ্রহ করে পিন কোড লিখুন।", "error");
                return;
            }

            if (email !== PERMANENT_ADMIN_EMAIL) {
                showToast("দুঃখিত! শুধুমাত্র নির্ধারিত অ্যাডমিন জিমেইল দিয়ে প্রবেশ করা যাবে।", "error");
                return;
            }

            const inputHash = await hashPin(pin);
            const storedHash = localStorage.getItem('tournament_admin_pin_hash') || DEFAULT_PIN_HASH;

            if (inputHash === storedHash) {
                sessionStorage.setItem('active_admin_pin', pin);
                document.getElementById('admin-lock-screen').classList.add('hidden');
                document.getElementById('admin-dashboard').classList.remove('hidden');
                document.getElementById('admin-pin-input').value = '';
                updateAdminStats();
                renderAdminList();
                lucide.createIcons();
                showToast(`স্বাগতম (${email})! ড্যাশবোর্ড আনলক হয়েছে।`, "success");
                fetchPlayersFromGoogleSheet();
            } else {
                showToast("ভুল পাসওয়ার্ড / পিন কোড! সঠিক পাসওয়ার্ড দিন।", "error");
            }
        }

        async function fetchPlayersFromGoogleSheet() {
            const scriptUrl = localStorage.getItem('tournament_google_script_url');
            const pin = sessionStorage.getItem('active_admin_pin');

            if (!scriptUrl || !pin) return;

            try {
                showToast("Google Sheet থেকে তথ্য লোড হচ্ছে...", "info");
                const response = await fetch(`${scriptUrl}?email=${encodeURIComponent(PERMANENT_ADMIN_EMAIL)}&pin=${encodeURIComponent(pin)}`);
                const result = await response.json();

                if (result.status === "success" && Array.isArray(result.players)) {
                    if (result.players.length > 0) {
                        players = result.players;
                        saveState();
                        updateAdminStats();
                        renderAdminList();
                        showToast(`সফলভাবে ${players.length} জন খেলোয়াড়ের অনলাইন তথ্য লোড হয়েছে!`, "success");
                    } else {
                        showToast("Google Sheet-এ এখনো কোনো নতুন নিবন্ধন জমা হয়নি।", "info");
                    }
                } else if (result.status === "unauthorized") {
                    showToast("নিরাপত্তা যাচাই ব্যর্থ! Apps Script-এর পিন এবং আপনার পিন একই হতে হবে।", "error");
                }
            } catch (err) {
                console.error("Fetch Error:", err);
                showToast("অনলাইন ডেটা লোড করতে সমস্যা হয়েছে (লিংক চেক করুন)।", "error");
            }
        }

        function lockAdmin() {
            sessionStorage.removeItem('active_admin_pin');
            document.getElementById('admin-dashboard').classList.add('hidden');
            document.getElementById('admin-lock-screen').classList.remove('hidden');
            document.getElementById('change-pin-box').classList.add('hidden');
        }

        function togglePinChangeModal() {
            const box = document.getElementById('change-pin-box');
            box.classList.toggle('hidden');
            if (!box.classList.contains('hidden')) {
                document.getElementById('global-notice-input').value = localStorage.getItem('tournament_global_notice') || DEFAULT_TOURNAMENT_NOTICE;
                document.getElementById('new-admin-email').value = PERMANENT_ADMIN_EMAIL;
                document.getElementById('new-admin-pin').value = '';
                document.getElementById('google-script-url-input').value = localStorage.getItem('tournament_google_script_url') || '';
            }
        }

        async function saveAdminSecuritySettings() {
            const noticeText = document.getElementById('global-notice-input').value.trim();
            const newPin = document.getElementById('new-admin-pin').value.trim();
            const scriptUrl = document.getElementById('google-script-url-input').value.trim();

            if (noticeText) {
                localStorage.setItem('tournament_global_notice', noticeText);
            }

            if (newPin) {
                if (newPin.length < 4) {
                    showToast("নিরাপত্তার স্বার্থে কমপক্ষে ৪ অক্ষরের পাসওয়ার্ড দিন!", "error");
                    return;
                }
                const newHash = await hashPin(newPin);
                localStorage.setItem('tournament_admin_pin_hash', newHash);
                sessionStorage.setItem('active_admin_pin', newPin);
            }

            if (scriptUrl) {
                localStorage.setItem('tournament_google_script_url', scriptUrl);
            } else {
                localStorage.removeItem('tournament_google_script_url');
            }

            togglePinChangeModal();
            showToast("টুর্নামেন্ট নোটিশ ও সেটিংস সফলভাবে সেভ হয়েছে!", "success");
        }

        function exportBackupJSON() {
            const backupPayload = {
                version: "1.0",
                exportedAt: new Date().toISOString(),
                players: players,
                votedNumbers: votedNumbers
            };
            const blob = new Blob([JSON.stringify(backupPayload, null, 2)], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement("a");
            const dateStr = new Date().toISOString().slice(0, 10);
            link.setAttribute("href", url);
            link.setAttribute("download", `tournament_backup_${dateStr}.json`);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            showToast("সম্পূর্ণ ডেটা ও ছবিসহ ব্যাকআপ ফাইল (.json) ডাউনলোড হয়েছে!", "success");
        }

        function importBackupJSON(event) {
            const file = event.target.files[0];
            if (!file) return;

            const reader = new FileReader();
            reader.onload = function(e) {
                try {
                    const parsed = JSON.parse(e.target.result);
                    if (!parsed || !Array.isArray(parsed.players)) {
                        showToast("ভুল ব্যাকআপ ফাইল! সঠিক .json ফাইল নির্বাচন করুন।", "error");
                        return;
                    }
                    players = parsed.players;
                    votedNumbers = Array.isArray(parsed.votedNumbers) ? parsed.votedNumbers : [];
                    saveState();
                    updateAdminStats();
                    renderAdminList();
                    renderVotingSection();
                    showToast(`সফলভাবে ${players.length} জন খেলোয়াড়ের তথ্য রিস্টোর করা হয়েছে!`, "success");
                } catch (err) {
                    showToast("ব্যাকআপ ফাইলটি পড়া সম্ভব হয়নি!", "error");
                }
                event.target.value = "";
            };
            reader.readAsText(file);
        }

        function updateAdminStats() {
            const total = players.length;
            const approved = players.filter(p => p.status === 'Approved').length;
            const pending = players.filter(p => p.status === 'Pending').length;
            const votes = players.reduce((sum, p) => sum + (p.votes || 0), 0);

            document.getElementById('stat-total').textContent = total;
            document.getElementById('stat-approved').textContent = approved;
            document.getElementById('stat-pending').textContent = pending;
            document.getElementById('stat-votes').textContent = votes;
        }

        function renderAdminList() {
            const container = document.getElementById('admin-players-list');
            const search = (document.getElementById('admin-search').value || '').toLowerCase();
            const statusFilter = document.getElementById('admin-filter-status').value;
            const sportFilter = document.getElementById('admin-filter-sport').value;

            const filtered = players.filter(p => {
                const matchSearch = p.fullName.toLowerCase().includes(search) || 
                                    p.mobile.includes(search) || 
                                    p.trxId.toLowerCase().includes(search) ||
                                    p.id.toLowerCase().includes(search);
                const matchStatus = statusFilter === 'ALL' || p.status === statusFilter;
                const matchSport = sportFilter === 'ALL' || p.sportType === sportFilter;
                return matchSearch && matchStatus && matchSport;
            });

            if (filtered.length === 0) {
                container.innerHTML = `<div class="p-8 text-center text-slate-500 text-sm">কোনো খেলোয়াড়ের তথ্য পাওয়া যায়নি।</div>`;
                return;
            }

            container.innerHTML = filtered.map(p => `
                <div class="p-5 hover:bg-slate-50/70 transition space-y-4">
                    <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
                        <div class="flex items-start gap-4">
                            <img src="${p.photo}" alt="${p.fullName}" class="w-16 h-16 rounded-xl object-cover border border-slate-300 shrink-0">
                            <div class="space-y-1">
                                <div class="flex flex-wrap items-center gap-2">
                                    <span class="font-mono text-xs font-bold px-2 py-0.5 bg-slate-200 text-slate-700 rounded">${p.id}</span>
                                    <h4 class="font-bold text-slate-800 text-base">${p.fullName}</h4>
                                    <span class="text-xs font-semibold px-2.5 py-0.5 rounded-full ${
                                        p.status === 'Approved' ? 'bg-emerald-100 text-emerald-700' :
                                        p.status === 'Rejected' ? 'bg-red-100 text-red-700' : 'bg-amber-100 text-amber-700'
                                    }">${p.status}</span>
                                </div>
                                <p class="text-xs text-slate-600">
                                    <strong>পিতা:</strong> ${p.fatherName} | <strong>মাতা:</strong> ${p.motherName} | <strong>NID:</strong> <span class="font-mono">${p.nidNumber}</span>
                                </p>
                                <p class="text-xs text-slate-600">
                                    <strong>ঠিকানা:</strong> পাড়া: ${p.para}, গ্রাম: ${p.village}, ইউনিয়ন: ${p.unionName}, উপজেলা: ${p.upazila}, জেলা: ${p.district}
                                </p>
                                <p class="text-xs text-emerald-700 font-medium">
                                    <strong>খেলা:</strong> ${p.sportType} (${p.playingRole}) • জার্সি: ${p.jerseySize} (#${p.jerseyNumber}) • মোবাইল: ${p.mobile}
                                </p>
                            </div>
                        </div>

                        <div class="flex items-center gap-2 self-end lg:self-center shrink-0">
                            <button onclick='openSlipModalById("${p.id}")' class="text-xs font-semibold px-3 py-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 flex items-center gap-1.5 transition">
                                <i data-lucide="id-card" class="w-3.5 h-3.5"></i> স্লিপ দেখুন
                            </button>
                            <button onclick="deletePlayer('${p.id}')" class="text-xs font-semibold px-3 py-2 rounded-xl bg-red-50 hover:bg-red-100 text-red-600 transition" title="মুছে ফেলুন">
                                <i data-lucide="trash-2" class="w-3.5 h-3.5"></i>
                            </button>
                        </div>
                    </div>

                    <div class="bg-slate-100/80 border border-slate-200/80 rounded-xl p-3.5 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 items-center">
                        <div class="bg-white p-2.5 rounded-lg border border-slate-200 flex items-center justify-between">
                            <div class="text-xs">
                                <span class="text-slate-400 block">${p.paymentMethod}</span>
                                <span class="font-mono font-bold text-slate-800">${p.trxId}</span>
                            </div>
                            <button onclick="togglePayment('${p.id}')" class="px-2.5 py-1 rounded-lg text-xs font-bold transition ${
                                p.paymentVerified 
                                ? 'bg-emerald-600 text-white' 
                                : 'bg-amber-100 text-amber-800 hover:bg-amber-200'
                            }">
                                ${p.paymentVerified ? '✓ Verified' : 'Verify করুন'}
                            </button>
                        </div>

                        <div>
                            <label class="block text-[11px] font-semibold text-slate-500 mb-1">আবেদন স্ট্যাটাস (কমিটি)</label>
                            <select onchange="updatePlayerField('${p.id}', 'status', this.value)" class="w-full px-3 py-1.5 rounded-lg border border-slate-300 text-xs font-semibold bg-white outline-none focus:border-emerald-500">
                                <option value="Pending" ${p.status === 'Pending' ? 'selected' : ''}>Pending (অপেক্ষমাণ)</option>
                                <option value="Approved" ${p.status === 'Approved' ? 'selected' : ''}>Approved (অনুমোদিত)</option>
                                <option value="Rejected" ${p.status === 'Rejected' ? 'selected' : ''}>Rejected (বাতিল)</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-[11px] font-semibold text-slate-500 mb-1">দল / গ্রুপ নির্ধারণ</label>
                            <input type="text" value="${p.assignedTeam}" onchange="updatePlayerField('${p.id}', 'assignedTeam', this.value)" placeholder="যেমন: গ্রুপ এ / দল-১" class="w-full px-3 py-1.5 rounded-lg border border-slate-300 text-xs bg-white outline-none focus:border-emerald-500">
                        </div>

                        <div>
                            <label class="block text-[11px] font-semibold text-slate-500 mb-1">পরিচালনা পরিষদের মন্তব্য</label>
                            <input type="text" value="${p.remarks}" onchange="updatePlayerField('${p.id}', 'remarks', this.value)" placeholder="কমিটির বিশেষ নোট লিখুন..." class="w-full px-3 py-1.5 rounded-lg border border-slate-300 text-xs bg-white outline-none focus:border-emerald-500">
                        </div>
                    </div>
                </div>
            `).join('');
            lucide.createIcons();
        }

        function openSlipModalById(id) {
            const p = players.find(item => item.id === id);
            if (p) openSlipModal(p);
        }

        function togglePayment(id) {
            const p = players.find(item => item.id === id);
            if (p) {
                p.paymentVerified = !p.paymentVerified;
                saveState();
                renderAdminList();
                showToast(p.paymentVerified ? "পেমেন্ট Verified হিসেবে চিহ্নিত হয়েছে।" : "পেমেন্ট Unverified করা হয়েছে।", "info");
            }
        }

        function updatePlayerField(id, field, value) {
            const p = players.find(item => item.id === id);
            if (p) {
                p[field] = value;
                saveState();
                updateAdminStats();
                renderAdminList();
                showToast("তথ্য সফলভাবে আপডেট করা হয়েছে।", "success");
            }
        }

        function deletePlayer(id) {
            players = players.filter(item => item.id !== id);
            saveState();
            updateAdminStats();
            renderAdminList();
            showToast("খেলোয়াড়ের নিবন্ধন মুছে ফেলা হয়েছে।", "info");
        }

        function exportCSV() {
            const headers = ["Reg ID", "Name", "Father", "Mother", "Mobile", "NID", "District", "Upazila", "Union", "Village", "Para", "Sport", "Role", "Jersey", "Payment Method", "TrxID", "Verified", "Status", "Assigned Team", "Remarks", "Votes"];
            const rows = players.map(p => [
                p.id, p.fullName, p.fatherName, p.motherName, p.mobile, `'${p.nidNumber}`,
                p.district, p.upazila, p.unionName, p.village, p.para,
                p.sportType, p.playingRole, `${p.jerseySize}-${p.jerseyNumber}`,
                p.paymentMethod, p.trxId, p.paymentVerified ? "Yes" : "No",
                p.status, p.assignedTeam, p.remarks, p.votes || 0
            ].map(val => `"${String(val).replace(/"/g, '""')}"`).join(","));

            const csvContent = "\uFEFF" + [headers.join(","), ...rows].join("\n");
            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement("a");
            link.setAttribute("href", url);
            link.setAttribute("download", "tournament_players_2026.csv");
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            showToast("খেলোয়াড়দের তালিকা (CSV) ডাউনলোড হচ্ছে।", "success");
        }

        // Initialize on page load
        window.addEventListener('DOMContentLoaded', () => {
            updateRoles();
            lucide.createIcons();
        });
    </script>
</body>
</html>
```
