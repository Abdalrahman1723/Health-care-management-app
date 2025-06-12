import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/symptoms.dart';
import '../cubit/prediction_cubit.dart';
import '../cubit/prediction_state.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final Map<String, List<MultiSelectCard>> _categorizedSymptoms = {};
  List<String> _selectedSymptoms = [];

  @override
  void initState() {
    super.initState();
    _initializeSymptomCards();
  }

  void _initializeSymptomCards() {
    _categorizedSymptoms['Skin'] = SkinSymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Respiratory'] = RespiratorySymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Gastrointestinal'] = GastrointestinalSymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Urinary'] = UrinarySymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Musculoskeletal'] = MusculoskeletalSymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Neurological'] = NeurologicalSymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['General'] = GeneralSymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Eye'] = EyeSymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Liver'] = LiverSymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Lymphatic'] = LymphaticSymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Nail'] = NailSymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Circulatory'] = CirculatorySymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Metabolic'] = MetabolicSymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Reproductive'] = ReproductiveSymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();

    _categorizedSymptoms['Other'] = OtherSymptoms.values
        .map((symptom) => MultiSelectCard(
              value: symptom.name,
              label: symptom.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim(),
              selected: false,
            ))
        .toList();
  }

  void _getPrediction(List<dynamic> selectedSymptoms) {
    setState(() {
      _selectedSymptoms = selectedSymptoms.map((e) => e.toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PredictionCubit, PredictionState>(
      listener: (context, state) {
        if (state is PredictionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              leading: IconButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                padding: const EdgeInsets.only(top: 12),
                decoration:
                    BoxDecoration(gradient: AppColors.containerBackground),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(height: 8.0),
                      Text(
                        "Get diagnosis with AI",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                ),
              ),
              centerTitle: true,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select your symptoms:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ..._categorizedSymptoms.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: AppColors.containerBackground,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: MultiSelectContainer(
                              suffix: MultiSelectSuffix(
                                selectedSuffix: const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                                disabledSuffix: const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ),
                              items: entry.value,
                              onChange: (allSelectedItems, selectedItem) {
                                _getPrediction(allSelectedItems);
                              },
                              itemsDecoration: MultiSelectDecorations(
                                selectedDecoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                              ),
                              textStyles: const MultiSelectTextStyles(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                selectedTextStyle: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: state is PredictionLoading
                            ? null
                            : () {
                                if (_selectedSymptoms.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please select at least one symptom'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                context
                                    .read<PredictionCubit>()
                                    .getPrediction(_selectedSymptoms);
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is PredictionLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Start Analysis',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'AI Prediction:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.containerBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: state is PredictionLoaded
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.predictedDisease,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.black,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                _buildInfoSection(
                                    'Precautions', state.precautions),
                                const SizedBox(height: 16),
                                _buildInfoSection(
                                    'Medications', state.medications),
                                const SizedBox(height: 16),
                                _buildInfoSection(
                                    'Recommended Diet', state.diets),
                                const SizedBox(height: 16),
                                _buildInfoSection(
                                    'Lifestyle & Workouts', state.workouts),
                              ],
                            )
                          : Text(
                              state is PredictionLoading
                                  ? 'Analyzing symptoms...'
                                  : 'Select your symptoms and click "Start Analysis" to get a prediction',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 25)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
