import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/providers/search/searchHelperProvider.dart';
import 'package:pet_mobile_social_flutter/services/search/search_db_helper.dart';
import 'package:pet_mobile_social_flutter/ui/search/search_result_scren.dart';

final searchProvider = FutureProvider<List<Searche>>((ref) async {
  final dbHelper = ref.read(dbHelperProvider);
  return dbHelper.getAllSearches();
});

class SearchScreen extends ConsumerWidget {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            onSubmitted: (name) async {
              final dbHelper = ref.read(dbHelperProvider);
              final search = SearchesCompanion(
                  name: Value(name),
                  image: Value(
                      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80'));

              // 검색어를 저장합니다.
              await dbHelper.insertSearch(search);

              // 검색 결과 화면으로 이동합니다.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResultScreen(),
                ),
              );

              ref.refresh(searchProvider);
            },
          ),
          Expanded(
            child: ref.watch(searchProvider).when(
                  data: (searches) {
                    if (searches.isEmpty) {
                      return Center(child: Text('No results'));
                    }

                    return ListView.builder(
                      itemCount: searches.length,
                      itemBuilder: (context, index) {
                        final search = searches[index];
                        return ListTile(
                          title: Text(search.name),
                          subtitle: Text(search.image!),
                          onTap: () async {
                            final dbHelper = ref.read(dbHelperProvider);
                            // 탭하면 검색 기록을 삭제합니다.
                            await dbHelper.deleteSearch(search);

                            // Refresh the provider to trigger the search again
                            ref.refresh(searchProvider);
                          },
                        );
                      },
                    );
                  },
                  error: (err, _) => Center(child: Text('Error: $err')),
                  loading: () {
                    return Center(child: CircularProgressIndicator());
                  },
                ),
          ),
        ],
      ),
    );
  }
}
