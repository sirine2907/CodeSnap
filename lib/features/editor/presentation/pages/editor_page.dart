import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/languages.dart';
import '../../../../injection_container.dart';
import '../../../export/presentation/widgets/export_sheet.dart';
import '../../../settings/presentation/cubit/theme_cubit.dart';
import '../../../snippets/domain/entities/snippet.dart';
import '../../../snippets/presentation/bloc/library_bloc.dart';
import '../../../snippets/presentation/pages/library_page.dart';
import '../bloc/editor_bloc.dart';
import '../widgets/code_card.dart';
import '../widgets/style_controls.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  // used to grab the card as an image
  final GlobalKey _cardKey = GlobalKey();

  late final TextEditingController _codeController;
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    final snippet = context.read<EditorBloc>().state.snippet;
    _codeController = TextEditingController(text: snippet.code);
    _titleController = TextEditingController(text: snippet.title);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      appBar: _buildAppBar(context, isWide),
      body: BlocConsumer<EditorBloc, EditorState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.message.isNotEmpty) {
            _showMessage(state.message);
          }
        },
        builder: (context, state) {
          if (isWide) {
            return Row(
              children: [
                Expanded(child: _buildPreview(state.snippet)),
                SizedBox(
                  width: 380,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(4, 8, 24, 24),
                    children: _buildSidePanel(state.snippet),
                  ),
                ),
              ],
            );
          }

          // phone layout: preview on top, then the fields
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              _buildPreview(state.snippet),
              const SizedBox(height: 16),
              ..._buildSidePanel(state.snippet),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isWide) {
    final isDark = context.watch<ThemeCubit>().state;

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.code_rounded, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          const Text(
            'CodeSnap',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'New snippet',
          icon: const Icon(Icons.add),
          onPressed: _startNewSnippet,
        ),
        IconButton(
          tooltip: 'My snippets',
          icon: const Icon(Icons.folder_open_outlined),
          onPressed: _openLibrary,
        ),
        IconButton(
          tooltip: isDark ? 'Light mode' : 'Dark mode',
          icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          onPressed: () => context.read<ThemeCubit>().toggle(),
        ),
        const SizedBox(width: 8),
        if (isWide) ...[
          OutlinedButton.icon(
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text('Save'),
            onPressed: _save,
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            icon: const Icon(Icons.ios_share_rounded),
            label: const Text('Export'),
            onPressed: _export,
          ),
        ] else ...[
          IconButton(
            tooltip: 'Save',
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: _save,
          ),
          IconButton.filled(
            tooltip: 'Export',
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: _export,
          ),
        ],
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildPreview(Snippet snippet) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: RepaintBoundary(
            key: _cardKey,
            child: CodeCard(snippet: snippet),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSidePanel(Snippet snippet) {
    final bloc = context.read<EditorBloc>();

    return [
      TextField(
        controller: _titleController,
        decoration: const InputDecoration(labelText: 'File name'),
        onChanged: (value) => bloc.add(EditorTitleChanged(value)),
      ),
      const SizedBox(height: 12),
      InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Language',
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: findLanguage(snippet.language).id,
            isExpanded: true,
            items: codeLanguages.map((language) {
              return DropdownMenuItem(
                value: language.id,
                child: Text(language.label),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                bloc.add(EditorLanguageChanged(value));
              }
            },
          ),
        ),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _codeController,
        minLines: 8,
        maxLines: 14,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 13),
        decoration: const InputDecoration(
          labelText: 'Code',
          hintText: 'Paste your code here',
          alignLabelWithHint: true,
        ),
        onChanged: (value) => bloc.add(EditorCodeChanged(value)),
      ),
      const SizedBox(height: 20),
      StyleControls(
        style: snippet.style,
        onChanged: (style) => bloc.add(EditorStyleChanged(style)),
      ),
    ];
  }

  void _startNewSnippet() {
    context.read<EditorBloc>().add(const EditorNewSnippetStarted());
    // read the fresh snippet on the next frame, after the bloc updated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snippet = context.read<EditorBloc>().state.snippet;
      _codeController.text = snippet.code;
      _titleController.text = snippet.title;
    });
  }

  Future<void> _openLibrary() async {
    final snippet = await Navigator.of(context).push<Snippet>(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<LibraryBloc>()..add(const LibraryStarted()),
          child: const LibraryPage(),
        ),
      ),
    );

    if (snippet == null || !mounted) return;

    _codeController.text = snippet.code;
    _titleController.text = snippet.title;
    context.read<EditorBloc>().add(EditorSnippetOpened(snippet));
  }

  void _save() {
    context.read<EditorBloc>().add(const EditorSaveRequested());
  }

  Future<void> _export() async {
    final bloc = context.read<EditorBloc>();
    final option = await ExportSheet.show(context, canSave: !Platform.isAndroid);
    if (option == null) return;

    final snippet = bloc.state.snippet;

    switch (option) {
      case ExportOption.savePng:
        final bytes = await _captureCard();
        bloc.add(EditorImageExported(bytes, share: false));
        break;
      case ExportOption.sharePng:
        final bytes = await _captureCard();
        bloc.add(EditorImageExported(bytes, share: true));
        break;
      case ExportOption.copyCode:
        await Clipboard.setData(ClipboardData(text: snippet.code));
        _showMessage('Code copied');
        break;
      case ExportOption.copyMarkdown:
        final markdown = '```${snippet.language}\n${snippet.code}\n```';
        await Clipboard.setData(ClipboardData(text: markdown));
        _showMessage('Markdown copied');
        break;
    }
  }

  // Renders the card at 2x so the PNG looks sharp.
  Future<Uint8List> _captureCard() async {
    final boundary =
        _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        width: 320,
      ));
  }
}
