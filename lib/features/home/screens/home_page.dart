import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:whats_up/main_injection_container.dart';
//  as di;

import '../../../core/routes/page_const.dart';
import '../../../shared/widgets/sigle_chate/show_image_and_video.dart';
import '../../calls/presentation/manager/my_call/my_call_history_cubit.dart';
import '../../calls/presentation/pages/calls_history.dart';
import '../../chat/presentation/pages/chat_page.dart';
import '../../status/domain/entities/status_entity.dart';
import '../../status/domain/entities/status_image_entity.dart';
import '../../status/domain/use_cases/get_my_status_future_usecase.dart';
import '../../status/presentation/manager/status/status_cubit.dart';
import '../../status/presentation/pages/status_page.dart';
import '../../../core/theme/style.dart';
import '../../user/domain/entities/user_entity.dart';
import '../../user/presentation/manager/get_single_user/get_single_user_cubit.dart';
import '../../user/presentation/manager/user/user_cubit.dart';
import '../../../core/providers/storage_provider.dart';

class HomePage extends StatefulWidget {
  final String uid;
  final int? index;

  const HomePage({super.key, required this.uid, this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(userId: widget.uid);
    BlocProvider.of<MyCallHistoryCubit>(context)
        .getMyCallHistory(uid: widget.uid);

    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);

    _tabController!.addListener(() {
      setState(() {
        _currentTabIndex = _tabController!.index;
      });
    });

    if (widget.index != null) {
      setState(() {
        _currentTabIndex = widget.index!;
        _tabController!.animateTo(1);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        BlocProvider.of<UserCubit>(context).updateUsers(
            userEntity: UserEntity(uid: widget.uid, isOnline: true));
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        BlocProvider.of<UserCubit>(context).updateUsers(
            userEntity: UserEntity(uid: widget.uid, isOnline: false));
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  final List<StatusImageEntity> _stories = [];

  List<File>? _selectedMedia;
  List<String>? _mediaTypes; // To store the type of each selected file

  Future<void> selectMedia() async {
    setState(() {
      _selectedMedia = null;
      _mediaTypes = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );
      if (result != null) {
        _selectedMedia = result.files.map((file) => File(file.path!)).toList();

        // Initialize the media types list
        _mediaTypes = List<String>.filled(_selectedMedia!.length, '');

        // Determine the type of each selected file
        for (int i = 0; i < _selectedMedia!.length; i++) {
          String extension =
              path.extension(_selectedMedia![i].path).toLowerCase();
          if (extension == '.jpg' ||
              extension == '.jpeg' ||
              extension == '.png') {
            _mediaTypes![i] = 'image';
          } else if (extension == '.mp4' ||
              extension == '.mov' ||
              extension == '.avi') {
            _mediaTypes![i] = 'video';
          }
        }

        setState(() {});
        print("mediaTypes = $_mediaTypes");
      } else {
        print("No file is selected.");
      }
    } catch (e) {
      print("Error while picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, state) {
        if (state is GetSingleUserLoaded) {
          final currentUser = state.userEntity;
          return Scaffold(
            appBar: AppBar(
              leadingWidth: 0,
              leading: SizedBox(),
              title: const Text(
                "WhatsApp",
                style: TextStyle(
                    fontSize: 20,
                    color: greyColor,
                    fontWeight: FontWeight.w600),
              ),
              actions: [
                Row(
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      color: greyColor,
                      size: 28,
                    ),
                    const SizedBox(width: 25),
                    const Icon(Icons.search, color: greyColor, size: 28),
                    const SizedBox(width: 10),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: greyColor,
                        size: 28,
                      ),
                      color: appBarColor,
                      iconSize: 28,
                      onSelected: (value) {},
                      itemBuilder: (context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: "Settings",
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageConst.settingsPage,
                                    arguments: widget.uid);
                              },
                              child: const Text('Settings')),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              bottom: TabBar(
                labelColor: tabColor,
                unselectedLabelColor: greyColor,
                indicatorColor: tabColor,
                controller: _tabController,
                tabs: const [
                  Tab(
                    child: Text(
                      "Chats",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Status",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Calls",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: switchFloatingActionButtonOnTabIndex(
                _currentTabIndex, currentUser),
            body: PopScope(
              canPop: false,
              onPopInvoked: (b) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              const Text("Are You Exit App"),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).maybePop();
                                      },
                                      child: const Text("NO")),
                                  TextButton(
                                      onPressed: () {
                                        exit(0);
                                      },
                                      child: const Text("OK")),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  ChatPage(uid: widget.uid),
                  StatusPage(currentUser: currentUser),
                  CallHistoryPage(
                    currentUser: currentUser,
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: tabColor,
          ),
        );
      },
    );
  }

  switchFloatingActionButtonOnTabIndex(int index, UserEntity currentUser) {
    switch (index) {
      case 0:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactsPage()));
              Navigator.pushNamed(context, PageConst.contactUsersPage,
                  arguments: widget.uid);
            },
            child: const Icon(
              Icons.message,
              color: Colors.white,
            ),
          );
        }
      case 1:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              selectMedia().then(
                (value) {
                  if (_selectedMedia != null && _selectedMedia!.isNotEmpty) {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return ShowMultiImageAndVideoPickedWidget(
                          selectedFiles: _selectedMedia!,
                          onTap: () {
                            _uploadImageStatus(currentUser);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }
                },
              );
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          );
        }
      case 2:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              Navigator.pushNamed(context, PageConst.callContactsPage);
            },
            child: const Icon(
              Icons.add_call,
              color: Colors.white,
            ),
          );
        }
      default:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {},
            child: const Icon(
              Icons.message,
              color: Colors.white,
            ),
          );
        }
    }
  }

  _uploadImageStatus(UserEntity currentUser) {
    var service =
        Provider.of<StorageProviderRemoteDataSource>(context, listen: false);
    service
        .uploadStatuses(
            files: _selectedMedia!, onComplete: (onCompleteStatusUpload) {})
        .then((statusImageUrls) {
      for (var i = 0; i < statusImageUrls.length; i++) {
        _stories.add(StatusImageEntity(
          url: statusImageUrls[i],
          type: _mediaTypes![i],
          viewers: const [],
        ));
      }

      sl<GetMyStatusFutureUseCase>().call(widget.uid).then((myStatus) {
        if (myStatus.isNotEmpty) {
          BlocProvider.of<StatusCubit>(context)
              .updateOnlyImageStatus(
                  status: StatusEntity(
                      statusId: myStatus.first.statusId, stories: _stories))
              .then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(
                  uid: widget.uid,
                  index: 1,
                ),
              ),
            );
          });
        } else {
          BlocProvider.of<StatusCubit>(context)
              .createStatus(
            status: StatusEntity(
                caption: "",
                createdAt: Timestamp.now(),
                stories: _stories,
                username: currentUser.userName,
                uid: currentUser.uid,
                profileUrl: currentUser.profileUrl,
                imageUrl: statusImageUrls[0],
                phoneNumber: currentUser.phoneNumber),
          )
              .then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(
                  uid: widget.uid,
                  index: 1,
                ),
              ),
            );
          });
        }
      });
    });
  }
}
