import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:vn_travel_companion/core/constants/transport_options.dart';
import 'package:vn_travel_companion/core/layouts/custom_appbar.dart';
import 'package:vn_travel_companion/core/utils/image_picker.dart';
import 'package:vn_travel_companion/core/utils/validators.dart';
import 'package:vn_travel_companion/features/trips/domain/entities/trip.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:vn_travel_companion/features/trips/presentation/bloc/trip/trip_bloc.dart';
import 'package:vn_travel_companion/features/trips/presentation/cubit/trip_details_cubit.dart';

class TripEditModal extends StatefulWidget {
  const TripEditModal({super.key});

  @override
  State<TripEditModal> createState() => _TripEditModalState();
}

class _TripEditModalState extends State<TripEditModal> {
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTimeRange? selectedDateRange;
  final controller = MultiSelectController<TransportOption>();
  File? image;
  String coverImage = "";

  void selectImage() async {
    log("Select image");
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  final List<DropdownItem<TransportOption>> items = transportOptions.map(
    (option) {
      return DropdownItem(
        label: option.label,
        value: option,
      );
    },
  ).toList();

  @override
  void initState() {
    super.initState();
    final tripTmp =
        (context.read<TripDetailsCubit>().state as TripDetailsLoadedSuccess)
            .trip;
    nameController.text = tripTmp.name;
    descriptionController.text = tripTmp.description ?? "";
    selectedDateRange = tripTmp.startDate != null
        ? DateTimeRange(
            start: tripTmp.startDate!,
            end: tripTmp.endDate!,
          )
        : null;
    if (tripTmp.transports != null) {
      controller.setItems(items
          .where(
            (element) => tripTmp.transports!.contains(element.value.value),
          )
          .toList());
    }
    coverImage = tripTmp.cover ?? "";
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppbar(
      appBarTitle: 'Chỉnh sửa chuyến đi',
      centerTitle: true,
      body: BlocConsumer<TripBloc, TripState>(
        listener: (context, state) {
          if (state is TripActionSuccess) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        builder: (context, state) => Stack(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 70),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ảnh bìa', // Label always on top
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: DottedBorder(
                            color: Theme.of(context).colorScheme.primary,
                            dashPattern: const [10, 4],
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            strokeCap: StrokeCap.round,
                            child: SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: image != null
                                      ? Image.file(
                                          image!,
                                          fit: BoxFit.cover,
                                        )
                                      : coverImage.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: coverImage,
                                              fit: BoxFit.cover,
                                            )
                                          : const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.folder_open,
                                                  size: 40,
                                                ),
                                                SizedBox(height: 15),
                                                Text(
                                                  'Select your image',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tên chuyến đi', // Label always on top
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                            height: 8), // Space between label and input box
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            hintText: 'Hãy đặt tên cho chuyến đi của bạn',
                          ),
                          validator: (value) => Validators.checkEmpty(value),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${nameController.text.length}/80", // Label always on top
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thời gian', // Label always on top
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                            height: 8), // Space between label and input box
                        OutlinedButton(
                          onPressed: () async {
                            final DateTimeRange? picked =
                                await showDateRangePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              initialDateRange: selectedDateRange,
                              locale: const Locale('vi', 'VN'),
                            );
                            if (picked != null && picked != selectedDateRange) {
                              setState(() {
                                selectedDateRange = picked;
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                              const SizedBox(width: 8),
                              Text(
                                  selectedDateRange != null
                                      ? "${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)}-${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}"
                                      : 'Chọn thời gian',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mô tả', // Label always on top
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                            height: 8), // Space between label and input box
                        TextFormField(
                          maxLines: 5,
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            hintText: 'Hãy viết mô tả chuyến đi của bạn',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${descriptionController.text.length}/1000", // Label always on top
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phương tiện', // Label always on top
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(
                            height: 8), // Space between label and input box

                        MultiDropdown<TransportOption>(
                          items: items,
                          controller: controller,
                          enabled: true,
                          chipDecoration: ChipDecoration(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            wrap: true,
                            runSpacing: 2,
                            spacing: 10,
                          ),
                          selectedItemBuilder: (item) {
                            return item.value.badge;
                          },
                          fieldDecoration: FieldDecoration(
                            hintText: 'Chọn phương tiện',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                            prefixIcon: const Icon(Icons.connecting_airports),
                            showClearIcon: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2),
                            ),
                          ),
                          dropdownDecoration: DropdownDecoration(
                            marginTop: 2,
                            maxHeight: 500,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                            header: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Chọn phương tiện cho chuyến đi',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          dropdownItemDecoration: DropdownItemDecoration(
                            selectedIcon: const Icon(Icons.check_box,
                                color: Colors.green),
                            disabledIcon:
                                Icon(Icons.lock, color: Colors.grey.shade300),
                            selectedBackgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          onSelectionChange: (selectedItems) {
                            debugPrint("OnSelectionChange: $selectedItems");
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              onPressed: () {
                if (formKey.currentState!.validate() &&
                    state is! TripActionLoading) {
                  context.read<TripBloc>().add(
                        UpdateTrip(
                          description: descriptionController.text.trim().isEmpty
                              ? null
                              : descriptionController.text,
                          startDate: selectedDateRange?.start,
                          endDate: selectedDateRange?.end,
                          transports: controller.selectedItems.isEmpty
                              ? null
                              : controller.selectedItems
                                  .map((e) => e.value.value)
                                  .toList(),
                          cover: image,
                          name: nameController.text,
                          tripId: (context.read<TripDetailsCubit>().state
                                  as TripDetailsLoadedSuccess)
                              .trip
                              .id,
                        ),
                      );
                }
              },
              child: state is! TripActionLoading
                  ? const Text('Lưu thay đổi',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Đang lưu thay đổi',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ],
                    ),
            ),
          )
        ]),
      ),
    );
  }
}
