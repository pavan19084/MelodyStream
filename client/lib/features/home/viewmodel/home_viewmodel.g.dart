// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllSongsHash() => r'fb39d2c396f6e7029b66b99f6e4e33d8a6d06499';

/// See also [getAllSongs].
@ProviderFor(getAllSongs)
final getAllSongsProvider = AutoDisposeFutureProvider<List<SongModel>>.internal(
  getAllSongs,
  name: r'getAllSongsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAllSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllSongsRef = AutoDisposeFutureProviderRef<List<SongModel>>;
String _$getFavSongsHash() => r'0be420ccb9121921785d3d7e4bcf195b62f8331c';

/// See also [getFavSongs].
@ProviderFor(getFavSongs)
final getFavSongsProvider = AutoDisposeFutureProvider<List<SongModel>>.internal(
  getFavSongs,
  name: r'getFavSongsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getFavSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetFavSongsRef = AutoDisposeFutureProviderRef<List<SongModel>>;
String _$homeViewModelHash() => r'5b6a29b94d143da7778a14c4dc54e31900fef5af';

/// See also [HomeViewModel].
@ProviderFor(HomeViewModel)
final homeViewModelProvider =
    AutoDisposeNotifierProvider<HomeViewModel, AsyncValue<void>>.internal(
  HomeViewModel.new,
  name: r'homeViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewModel = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
