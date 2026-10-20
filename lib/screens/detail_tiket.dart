import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/* ---------------- DATA ---------------- */
enum _Currency { idr, usd, eur, jpy }

enum _Category { wni, wna }

/// Kurs: berapa Rupiah untuk 1 unit mata uang.
/// CATATAN: ini nilai tetap (statis). Ganti dengan hasil API kurs
/// kalau mau real-time (mis. exchangerate.host / frankfurter.app).
const Map<_Currency, double> _idrPerUnit = {
  _Currency.idr: 1,
  _Currency.usd: 16500,
  _Currency.eur: 19200,
  _Currency.jpy: 108,
};

const Map<_Currency, String> _currencyLabel = {
  _Currency.idr: 'IDR (Rp)',
  _Currency.usd: 'USD (\$)',
  _Currency.eur: 'EUR (€)',
  _Currency.jpy: 'JPY (¥)',
};

/// Harga dasar selalu dalam Rupiah.
const Map<_Category, int> _basePriceIdr = {
  _Category.wni: 15000,
  _Category.wna: 25000,
};

String _formatPrice(int idr, _Currency c) {
  switch (c) {
    case _Currency.idr:
      return NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(idr);
    case _Currency.usd:
      return NumberFormat.currency(
        locale: 'en_US',
        symbol: '\$',
        decimalDigits: 2,
      ).format(idr / _idrPerUnit[c]!);
    case _Currency.eur:
      return NumberFormat.currency(
        locale: 'en_US',
        symbol: '€',
        decimalDigits: 2,
      ).format(idr / _idrPerUnit[c]!);
    case _Currency.jpy:
      return NumberFormat.currency(
        locale: 'en_US',
        symbol: '¥',
        decimalDigits: 0,
      ).format(idr / _idrPerUnit[c]!);
  }
}

/* ---------------- WARNA (sama dengan beranda) ---------------- */
const _kGreen = Color(0xFF1A3C34);
const _kGold = Color(0xFFB8862B);
const _kGoldSoft = Color(0xFFF6D58E);
const _kBg = Color(0xFFFDF8F0);
const _kBorder = Color(0xFFEADFCB);
const _kMuted = Color(0xFF6B7A75);

/* ---------------- SCREEN ---------------- */
class ShowDetailScreen extends StatefulWidget {
  final String title;
  final String day;
  final String image;

  const ShowDetailScreen({
    super.key,
    required this.title,
    required this.day,
    required this.image,
  });

  @override
  State<ShowDetailScreen> createState() => _ShowDetailScreenState();
}

class _ShowDetailScreenState extends State<ShowDetailScreen> {
  _Currency _currency = _Currency.idr;
  _Category _category = _Category.wni;
  bool _saved = false;

  String get _categoryName =>
      _category == _Category.wni ? 'WNI Reguler' : 'WNA Foreigner';

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      minScaleFactor: 1.0,
      maxScaleFactor: 1.3,
      child: Scaffold(
        backgroundColor: _kBg,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHero(),
                          const SizedBox(height: 16),
                          _buildScheduleCard(),
                          const SizedBox(height: 16),
                          _buildTicketCard(),
                          const SizedBox(height: 16),
                          _buildReviewCard(),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomBar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* ---------- TOP BAR ---------- */
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: _kGreen),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Detail Pentas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _kGreen,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _saved ? Icons.bookmark : Icons.bookmark_border,
              color: _saved ? _kGold : _kGreen,
            ),
            onPressed: () => setState(() => _saved = !_saved),
          ),
        ],
      ),
    );
  }

  /* ---------- HERO ---------- */
  Widget _buildHero() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: _kGreen,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            widget.image,
            fit: BoxFit.cover,
            cacheWidth: 1000,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFD9D9D9),
              alignment: Alignment.center,
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: Colors.black38,
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.2, 1.0],
                colors: [Color(0x330B1F1A), Color(0xE60B1F1A)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _kGoldSoft.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _kGold),
                  ),
                  child: const Text(
                    'Pentas Sakral Keraton',
                    style: TextStyle(
                      color: _kGoldSoft,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: _kGoldSoft, size: 14),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Bangsal Srimanganti, Keraton Yogyakarta',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* ---------- JADWAL ---------- */
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: Color(0xFF9AA6A2),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _kGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleCard() {
    return _card(
      child: Column(
        children: [
          _infoRow(
            icon: Icons.calendar_month_outlined,
            iconColor: _kGreen,
            bgColor: const Color(0xFFE8EFEC),
            label: 'JADWAL RUTIN',
            value: 'Setiap ${widget.day}, 09.00 - 11.00 WIB',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF0E8D8)),
          ),
          _infoRow(
            icon: Icons.schedule,
            iconColor: const Color(0xFFE08A1E),
            bgColor: const Color(0xFFFFF3E0),
            label: 'DURASI PEMENTASAN',
            value: '120 Menit (Tanpa Jeda)',
          ),
        ],
      ),
    );
  }

  /* ---------- TIKET ---------- */
  Widget _buildTicketCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Kategori & Mata Uang',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _kGreen,
            ),
          ),
          const SizedBox(height: 14),
          _CurrencySelector(
            selected: _currency,
            onChanged: (c) => setState(() => _currency = c),
          ),
          const SizedBox(height: 14),
          _CategoryTile(
            title: 'WNI (Reguler)',
            price:
                '${_formatPrice(_basePriceIdr[_Category.wni]!, _currency)} / orang',
            selected: _category == _Category.wni,
            onTap: () => setState(() => _category = _Category.wni),
          ),
          const SizedBox(height: 10),
          _CategoryTile(
            title: 'WNA (Foreigner)',
            price:
                '${_formatPrice(_basePriceIdr[_Category.wna]!, _currency)} / orang',
            selected: _category == _Category.wna,
            onTap: () => setState(() => _category = _Category.wna),
          ),
          if (_currency != _Currency.idr) ...[
            const SizedBox(height: 10),
            Text(
              'Perkiraan kurs: 1 ${_currencyLabel[_currency]!.split(' ').first} '
              '≈ ${NumberFormat.decimalPattern('id_ID').format(_idrPerUnit[_currency])} IDR. '
              'Pembayaran tetap dalam Rupiah.',
              style: const TextStyle(fontSize: 11, color: _kMuted, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }

  /* ---------- ULASAN ---------- */
  Widget _buildReviewCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Ulasan Penonton',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _kGreen,
                  ),
                ),
              ),
              Icon(Icons.star_rounded, color: Color(0xFFF5A623), size: 18),
              SizedBox(width: 4),
              Text(
                '4.9',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _kGreen,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 4),
              Text('(1.420)', style: TextStyle(color: _kMuted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '98% penonton memuji suasana sakral dan berwibawa pada pentas '
            '${widget.title} di Bangsal Srimanganti.',
            style: const TextStyle(fontSize: 12.5, color: _kMuted, height: 1.6),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEEF1F4)),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFC9D6E0),
                  child: Text(
                    'BS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _kGreen,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"Pengalaman cultural tak terlupakan di Jogja!"',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: _kGreen,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Budi S. • Terverifikasi',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9AA6A2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* ---------- BOTTOM BAR ---------- */
  Widget _buildBottomBar() {
    final price = _formatPrice(_basePriceIdr[_category]!, _currency);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'KATEGORI DIPILIH',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: Color(0xFF9AA6A2),
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    '$_categoryName • $price',
                    key: ValueKey('$_categoryName$price'),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _kGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _kGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Memesan tiket $_categoryName (${widget.title}) — segera hadir',
                  ),
                ),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pesan Tiket',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- SELEKTOR MATA UANG (pil geser animasi) ---------------- */
class _CurrencySelector extends StatelessWidget {
  final _Currency selected;
  final ValueChanged<_Currency> onChanged;

  const _CurrencySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const values = _Currency.values;
    final index = values.indexOf(selected);

    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segW = constraints.maxWidth / values.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: segW * index,
                top: 0,
                bottom: 0,
                width: segW,
                child: Container(
                  decoration: BoxDecoration(
                    color: _kGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                children: values.map((c) {
                  final isSel = c == selected;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(c),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSel ? Colors.white : _kMuted,
                            ),
                            child: Text(_currencyLabel[c]!),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

/* ---------------- KARTU KATEGORI (radio titik) ---------------- */
class _CategoryTile extends StatelessWidget {
  final String title;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.title,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 250);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _kGreen : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _kGreen : const Color(0xFFE3E8EC),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: duration,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : _kGreen,
                    ),
                    child: Text(title),
                  ),
                  const SizedBox(height: 3),
                  AnimatedDefaultTextStyle(
                    duration: duration,
                    style: TextStyle(
                      fontSize: 12,
                      color: selected ? const Color(0xFFCFE0DA) : _kMuted,
                    ),
                    child: Text(price),
                  ),
                ],
              ),
            ),
            // Radio: lingkaran luar + titik di tengah yang membesar/mengecil
            AnimatedContainer(
              duration: duration,
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? _kGoldSoft : const Color(0xFFCBD3D8),
                  width: 2,
                ),
              ),
              child: AnimatedScale(
                scale: selected ? 1 : 0,
                duration: duration,
                curve: Curves.easeOutBack,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _kGoldSoft,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
